Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E041410D5
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgAQSb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jan 2020 13:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgAQSb7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 13:31:59 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCD220728;
        Fri, 17 Jan 2020 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579285918;
        bh=NxNE+OH1CpS71VbqsH5SIfSLtMW+713VKoPKqz2h6n4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FqpXHD3NtdX1IlznS0qvwBbVq9LZ1MGwbbW1JIU6Wf7hfC9lfunmu8yQmYYpPJMsd
         beg0D0S8T4IRYw7fzao6dmwtZPFg14JxFFc7zQlbi70EQLFp/W2kZYQespMbZ2job2
         JzTnBdCBgwUdsgIU5y+EFMM3aYaiH5YLcTv8DdCE=
Message-ID: <c170d5d3ccec27a2c6a4ec1a7dd8265746356acf.camel@kernel.org>
Subject: Re: [RFC PATCH v2 08/10] ceph: add new MDS req field to hold
 delegated inode number
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Date:   Fri, 17 Jan 2020 13:31:56 -0500
In-Reply-To: <CAOi1vP96P89S2uMF81kuKgLcb7MDR-GGonr665S=rR87+Otsgw@mail.gmail.com>
References: <20200115205912.38688-1-jlayton@kernel.org>
         <20200115205912.38688-9-jlayton@kernel.org>
         <CAOi1vP_oXUTLfhMU6qWfk9Ha=09BdmwF52MeoytKHQWz+Mfwdw@mail.gmail.com>
         <374a760e8fae44e5cbdfd1bafa1f8f318e23770f.camel@kernel.org>
         <CAOi1vP96P89S2uMF81kuKgLcb7MDR-GGonr665S=rR87+Otsgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-01-17 at 18:42 +0100, Ilya Dryomov wrote:
> On Fri, Jan 17, 2020 at 5:53 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Fri, 2020-01-17 at 15:47 +0100, Ilya Dryomov wrote:
> > > On Wed, Jan 15, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > Add new request field to hold the delegated inode number. Encode that
> > > > into the message when it's set.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/mds_client.c | 3 +--
> > > >  fs/ceph/mds_client.h | 1 +
> > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index e49ca0533df1..b8070e8c4686 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -2466,7 +2466,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> > > >         head->op = cpu_to_le32(req->r_op);
> > > >         head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
> > > >         head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
> > > > -       head->ino = 0;
> > > > +       head->ino = cpu_to_le64(req->r_deleg_ino);
> > > >         head->args = req->r_args;
> > > > 
> > > >         ceph_encode_filepath(&p, end, ino1, path1);
> > > > @@ -2627,7 +2627,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> > > >         rhead->flags = cpu_to_le32(flags);
> > > >         rhead->num_fwd = req->r_num_fwd;
> > > >         rhead->num_retry = req->r_attempts - 1;
> > > > -       rhead->ino = 0;
> > > > 
> > > >         dout(" r_parent = %p\n", req->r_parent);
> > > >         return 0;
> > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > index 2a32afa15eb6..0811543ffd79 100644
> > > > --- a/fs/ceph/mds_client.h
> > > > +++ b/fs/ceph/mds_client.h
> > > > @@ -308,6 +308,7 @@ struct ceph_mds_request {
> > > >         int               r_num_fwd;    /* number of forward attempts */
> > > >         int               r_resend_mds; /* mds to resend to next, if any*/
> > > >         u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> > > > +       unsigned long     r_deleg_ino;
> > > 
> > > u64, as head->ino is __le64?
> > > 
> > 
> > Does that actually matter? It should get promoted to 64 bit when we do
> > the encoding since we're passing by value, and this will never be larger
> > than 32 bits on a 32 bit box.
> 
> It raises eyebrows -- one needs to remember that inode numbers
> fit into unsigned long when looking at the code.  We are using u64
> for inode numbers throughout ceph.ko: ceph_vino, ino parameters to
> various functions, etc -- not just in the wire format definitions.
> I think sticking to u64 is more clear and consistent.
> 

Yeah, now that I think about it, you're right. This is going to be a
inode presented to the MDS, so it will always need to be 64-bit. Fixed
in my tree.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

