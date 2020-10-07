Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906B286600
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgJGRdR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJGRdR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Oct 2020 13:33:17 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC7CC061755
        for <ceph-devel@vger.kernel.org>; Wed,  7 Oct 2020 10:33:17 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b2so3053772ilr.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Oct 2020 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/hUHpHElna/bonvb/FNbIX8jV/IHxuGzuYJlRi9c9k=;
        b=A6lWZBlZplukM7kxxdMWwquTpl+ACk4VioQlzGDdgmROJCNvUWPqQ6+mJaGpLwe/gB
         pwluq3OVs+MpXSfTtHn2PEF6Mm5mpI9SMknGebW5kbpU7r6wXL7YWXMewoXpJ9GgkXnN
         NW84gMEBkfkjbGAyloScXylkZMrg1ZmSKztun0Lhnh04mzOSgWRWnrdyStnGvo8Cu+Z4
         WTWv03mxIpzqtmZyLhK/tjb5Wn9kADNXprK113zfZtrH6ZlRjXSfQM/iONb2dLQbZPG9
         U0XKd/PwZI+VTB0WUXaJoiCx5MC54rKhFNM4aIJ28ws8z2lrRZlNc82lyWDMI9tvuWQI
         CtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/hUHpHElna/bonvb/FNbIX8jV/IHxuGzuYJlRi9c9k=;
        b=F7ks9NCaQCpeKO4eb1x9Z1kIt4EP7cYX5Qc/o2aErQkXAZ/3ShmSykZv7TgQNSmMaN
         ZmFwVGQgRn3WCUXeFRGr0B7Pcn269JI8K6VB+HVeB3x0x0yP2fz7iEY55WyHZbnIbIDL
         kzzTYgFTUzoofmivTGBbUbxDJlF+BZ//AH22AMlXkFVTeYQtjeksi56cHGqquyKJqQlx
         X7UQu373LSoNnnnwBzLoarKbviWglSV4zBXguqC6vTGH9egH75iO9FUnOC4yBYa9PJuS
         Hpq1ELNdwoBgUN+wXgto8dJDWDj7eXq7JK617AYepoGku7epdz1r/PmADRIhTSEn6KHT
         vyLQ==
X-Gm-Message-State: AOAM5316ZjYyXaAuM/ulHjMaG+Q0uUctjIAdl4CsDO0ZW7HNQJIx/6O0
        7JKI7CGsPFM6dcmaM7SyzGv/WEQ/1nsPF/9UqNE=
X-Google-Smtp-Source: ABdhPJz1EHqAsSimjgGkgi5ohghv2VvA/zm8CnvFqu4Rwh7jFx89Z1M9886aX9vtcCUZwcqFP6FCjfEZmMIGF8XDeP4=
X-Received: by 2002:a92:6711:: with SMTP id b17mr3850917ilc.100.1602091996389;
 Wed, 07 Oct 2020 10:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201007122536.13354-1-jlayton@kernel.org>
In-Reply-To: <20201007122536.13354-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Oct 2020 19:33:08 +0200
Message-ID: <CAOi1vP-uJnznmKLSSRymj1FDXWKf4uD1NLuGVse5Nokr=4JQ=w@mail.gmail.com>
Subject: Re: [PATCH] ceph: break up send_cap_msg
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 7, 2020 at 2:25 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Push the allocation of the msg and the send into the caller. Rename
> the function to marshal_cap_msg and make it void return.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 61 +++++++++++++++++++++++++-------------------------
>  1 file changed, 30 insertions(+), 31 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 4e84b39a6ebd..6f4adfaf761f 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1222,36 +1222,29 @@ struct cap_msg_args {
>  };
>
>  /*
> - * Build and send a cap message to the given MDS.
> - *
> - * Caller should be holding s_mutex.
> + * cap struct size + flock buffer size + inline version + inline data size +
> + * osd_epoch_barrier + oldest_flush_tid
>   */
> -static int send_cap_msg(struct cap_msg_args *arg)
> +#define CAP_MSG_SIZE (sizeof(struct ceph_mds_caps) + \
> +                     4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4)
> +
> +/* Marshal up the cap msg to the MDS */
> +static void marshal_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)

Nit: functions like this usually have "encode" or "build" in their
names across the codebase, so I'd go with "encode_cap_msg".


>  {
>         struct ceph_mds_caps *fc;
> -       struct ceph_msg *msg;
>         void *p;
> -       size_t extra_len;
>         struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
>
> -       dout("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s"
> +       dout("%s %s %llx %llx caps %s wanted %s dirty %s"
>              " seq %u/%u tid %llu/%llu mseq %u follows %lld size %llu/%llu"
> -            " xattr_ver %llu xattr_len %d\n", ceph_cap_op_name(arg->op),
> -            arg->cid, arg->ino, ceph_cap_string(arg->caps),
> -            ceph_cap_string(arg->wanted), ceph_cap_string(arg->dirty),
> -            arg->seq, arg->issue_seq, arg->flush_tid, arg->oldest_flush_tid,
> -            arg->mseq, arg->follows, arg->size, arg->max_size,
> -            arg->xattr_version,
> +            " xattr_ver %llu xattr_len %d\n", __func__,
> +            ceph_cap_op_name(arg->op), arg->cid, arg->ino,
> +            ceph_cap_string(arg->caps), ceph_cap_string(arg->wanted),
> +            ceph_cap_string(arg->dirty), arg->seq, arg->issue_seq,
> +            arg->flush_tid, arg->oldest_flush_tid, arg->mseq, arg->follows,
> +            arg->size, arg->max_size, arg->xattr_version,
>              arg->xattr_buf ? (int)arg->xattr_buf->vec.iov_len : 0);
>
> -       /* flock buffer size + inline version + inline data size +
> -        * osd_epoch_barrier + oldest_flush_tid */
> -       extra_len = 4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4;
> -       msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc) + extra_len,
> -                          GFP_NOFS, false);
> -       if (!msg)
> -               return -ENOMEM;
> -
>         msg->hdr.version = cpu_to_le16(10);
>         msg->hdr.tid = cpu_to_le64(arg->flush_tid);
>
> @@ -1323,9 +1316,6 @@ static int send_cap_msg(struct cap_msg_args *arg)
>
>         /* Advisory flags (version 10) */
>         ceph_encode_32(&p, arg->flags);
> -
> -       ceph_con_send(&arg->session->s_con, msg);
> -       return 0;
>  }
>
>  /*
> @@ -1456,22 +1446,24 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>   */
>  static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
>  {
> +       struct ceph_msg *msg;
>         struct inode *inode = &ci->vfs_inode;
> -       int ret;
>
> -       ret = send_cap_msg(arg);
> -       if (ret < 0) {
> -               pr_err("error sending cap msg, ino (%llx.%llx) "
> -                      "flushing %s tid %llu, requeue\n",
> +       msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
> +       if (!msg) {
> +               pr_err("error allocating cap msg: ino (%llx.%llx) "
> +                      "flushing %s tid %llu, requeuing cap.\n",

Don't break new user-visible strings.  This makes grepping harder than
it should be.

Thanks,

                Ilya
