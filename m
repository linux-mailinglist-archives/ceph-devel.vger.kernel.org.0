Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3020E286654
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 19:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgJGRzf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 13:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgJGRzf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:35 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C3B42173E;
        Wed,  7 Oct 2020 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602093334;
        bh=rXnfFXaL4x/s4j3HU17U4XoZDFp0tfaBlQ+apdQ8Emw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SMBE51taJuyCasLGhPOMLFkXqMC7kNy46vvaZEVkGD7RD+8R9atxd0GA0sICHIOEf
         E/EUTYYoL/AjbA6UHdbDSYT3xAISY7WaSmYdfAiuvorQJiXuLLO/WTX6BSGQ+e2FmU
         qKfXd7ZxEsQPvJxXnp1856oT9n4dA0w/phlWaCTw=
Message-ID: <66cf13245fe6684d2f81dd848c7cfe1256790a6e.camel@kernel.org>
Subject: Re: [PATCH] ceph: break up send_cap_msg
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 07 Oct 2020 13:55:32 -0400
In-Reply-To: <CAOi1vP-uJnznmKLSSRymj1FDXWKf4uD1NLuGVse5Nokr=4JQ=w@mail.gmail.com>
References: <20201007122536.13354-1-jlayton@kernel.org>
         <CAOi1vP-uJnznmKLSSRymj1FDXWKf4uD1NLuGVse5Nokr=4JQ=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-10-07 at 19:33 +0200, Ilya Dryomov wrote:
> On Wed, Oct 7, 2020 at 2:25 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Push the allocation of the msg and the send into the caller. Rename
> > the function to marshal_cap_msg and make it void return.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c | 61 +++++++++++++++++++++++++-------------------------
> >  1 file changed, 30 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 4e84b39a6ebd..6f4adfaf761f 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1222,36 +1222,29 @@ struct cap_msg_args {
> >  };
> > 
> >  /*
> > - * Build and send a cap message to the given MDS.
> > - *
> > - * Caller should be holding s_mutex.
> > + * cap struct size + flock buffer size + inline version + inline data size +
> > + * osd_epoch_barrier + oldest_flush_tid
> >   */
> > -static int send_cap_msg(struct cap_msg_args *arg)
> > +#define CAP_MSG_SIZE (sizeof(struct ceph_mds_caps) + \
> > +                     4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4)
> > +
> > +/* Marshal up the cap msg to the MDS */
> > +static void marshal_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
> 
> Nit: functions like this usually have "encode" or "build" in their
> names across the codebase, so I'd go with "encode_cap_msg".
> 
> 
> >  {
> >         struct ceph_mds_caps *fc;
> > -       struct ceph_msg *msg;
> >         void *p;
> > -       size_t extra_len;
> >         struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
> > 
> > -       dout("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s"
> > +       dout("%s %s %llx %llx caps %s wanted %s dirty %s"
> >              " seq %u/%u tid %llu/%llu mseq %u follows %lld size %llu/%llu"
> > -            " xattr_ver %llu xattr_len %d\n", ceph_cap_op_name(arg->op),
> > -            arg->cid, arg->ino, ceph_cap_string(arg->caps),
> > -            ceph_cap_string(arg->wanted), ceph_cap_string(arg->dirty),
> > -            arg->seq, arg->issue_seq, arg->flush_tid, arg->oldest_flush_tid,
> > -            arg->mseq, arg->follows, arg->size, arg->max_size,
> > -            arg->xattr_version,
> > +            " xattr_ver %llu xattr_len %d\n", __func__,
> > +            ceph_cap_op_name(arg->op), arg->cid, arg->ino,
> > +            ceph_cap_string(arg->caps), ceph_cap_string(arg->wanted),
> > +            ceph_cap_string(arg->dirty), arg->seq, arg->issue_seq,
> > +            arg->flush_tid, arg->oldest_flush_tid, arg->mseq, arg->follows,
> > +            arg->size, arg->max_size, arg->xattr_version,
> >              arg->xattr_buf ? (int)arg->xattr_buf->vec.iov_len : 0);
> > 
> > -       /* flock buffer size + inline version + inline data size +
> > -        * osd_epoch_barrier + oldest_flush_tid */
> > -       extra_len = 4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4;
> > -       msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc) + extra_len,
> > -                          GFP_NOFS, false);
> > -       if (!msg)
> > -               return -ENOMEM;
> > -
> >         msg->hdr.version = cpu_to_le16(10);
> >         msg->hdr.tid = cpu_to_le64(arg->flush_tid);
> > 
> > @@ -1323,9 +1316,6 @@ static int send_cap_msg(struct cap_msg_args *arg)
> > 
> >         /* Advisory flags (version 10) */
> >         ceph_encode_32(&p, arg->flags);
> > -
> > -       ceph_con_send(&arg->session->s_con, msg);
> > -       return 0;
> >  }
> > 
> >  /*
> > @@ -1456,22 +1446,24 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
> >   */
> >  static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
> >  {
> > +       struct ceph_msg *msg;
> >         struct inode *inode = &ci->vfs_inode;
> > -       int ret;
> > 
> > -       ret = send_cap_msg(arg);
> > -       if (ret < 0) {
> > -               pr_err("error sending cap msg, ino (%llx.%llx) "
> > -                      "flushing %s tid %llu, requeue\n",
> > +       msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
> > +       if (!msg) {
> > +               pr_err("error allocating cap msg: ino (%llx.%llx) "
> > +                      "flushing %s tid %llu, requeuing cap.\n",
> 
> Don't break new user-visible strings.  This makes grepping harder than
> it should be.
> 
> Thanks,
> 
>                 Ilya

Thanks Ilya,

I fixed both issues and pushed the result into testing branch. I won't
bother re-posting unless there are other changes that I need to make.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

