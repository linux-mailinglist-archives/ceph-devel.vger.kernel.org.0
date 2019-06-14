Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6727845749
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 10:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFNIRn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 04:17:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36682 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfFNIRn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 04:17:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so1526295qtl.3
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 01:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aaLU90yx25J8Lq3S7JM2HHthDUqZaBZOrD0MXMXw2Fo=;
        b=ctcFzLOW/kOT9G+5eH+Ol/ygHS1htfFWktCVrnBBIBtORdb+G53zrs9VpnyIz5v0wn
         nZDm2Emv4Kyc2QZ4Jtz3a9WHVkBd2A+y12/VKnk07us4kXL3GthO+xkXzW9VUE1iytc3
         +DEkgv3LVwIqPgSfMudFNdtcb+j/F9K3O1HIcFXr7Nbj3gcGjzs/crlYGA+iqWMfaZqa
         +NF3ANXN1WBxKb3mzouofS5xPWbcvSHqQ58pcBApSg4PJr28A4ZIh8Crsw4fkh9ANIrF
         Sw9VHjWSsjuIY6NPtjAJC/ysvJDKap8YN60SRaz3kWyPH9+qkDI/pqia2wC5vivOjFLJ
         KDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaLU90yx25J8Lq3S7JM2HHthDUqZaBZOrD0MXMXw2Fo=;
        b=kfo+qcozaB9qyc2+/1k9PjcR1N1XUhxNLGncI7Pq6t5vTOs25fYU62OMqVmfQU7LNC
         dmYddzMQVBrvIfw5bKRu2MRmnsuomfWC0AWjnvkCFPl7AtLFbqtvYqAG/akTBY2407es
         aRvw9Wv5Li7SL+k+/c9H+YnN8lAQi5J6sS9F9g+BM8V92EkVJVJqm2MIULOnvjZXmsbo
         0y4s/3v2SQNq6tcUeQfVb6XvfWB8p739XhzqepsNWtk3FR2ybuVDtH2tdaXbjk09/5UD
         O1tqf3VGdJHd2p9bxOeCKnXRizqJDs+2jsayrRQBZnCuZLFNtS8qbROzff3wUvVL5Nf3
         bExQ==
X-Gm-Message-State: APjAAAUkrqCA0hmHFz2Q48dGyEZGbM7qiejvU0C3Racy5Gk6VGy0tDo5
        s+d6gE3KTNxSmumoWYoQYCnHpL4EAfd48RgUt1w=
X-Google-Smtp-Source: APXvYqyVUnqvPidf4edGsV8wlC8d90VkvbS0duxPiIAWA/yz4c9O9ZoaPJBvINP6YpX3MYZjpvkioc7FmmYmCKUNY54=
X-Received: by 2002:ac8:87d:: with SMTP id x58mr79866828qth.368.1560500261749;
 Fri, 14 Jun 2019 01:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153816.12918-1-jlayton@kernel.org> <20190607153816.12918-11-jlayton@kernel.org>
In-Reply-To: <20190607153816.12918-11-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 14 Jun 2019 16:17:30 +0800
Message-ID: <CAAM7YAkaJJngkPzWEMhtXWULEWpvqNhSgGiWOHNL1Czpo=obLw@mail.gmail.com>
Subject: Re: [PATCH 10/16] ceph: handle btime in cap messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 7, 2019 at 11:38 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c  | 18 ++++++++++++------
>  fs/ceph/snap.c  |  1 +
>  fs/ceph/super.h |  2 +-
>  3 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 50409d9fdc90..623b82684e90 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1139,7 +1139,7 @@ struct cap_msg_args {
>         u64                     flush_tid, oldest_flush_tid, size, max_size;
>         u64                     xattr_version;
>         struct ceph_buffer      *xattr_buf;
> -       struct timespec64       atime, mtime, ctime;
> +       struct timespec64       atime, mtime, ctime, btime;
>         int                     op, caps, wanted, dirty;
>         u32                     seq, issue_seq, mseq, time_warp_seq;
>         u32                     flags;
> @@ -1160,7 +1160,6 @@ static int send_cap_msg(struct cap_msg_args *arg)
>         struct ceph_msg *msg;
>         void *p;
>         size_t extra_len;
> -       struct timespec64 zerotime = {0};
>         struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
>
>         dout("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s"
> @@ -1251,7 +1250,7 @@ static int send_cap_msg(struct cap_msg_args *arg)
>          * We just zero these out for now, as the MDS ignores them unless
>          * the requisite feature flags are set (which we don't do yet).
>          */
> -       ceph_encode_timespec64(p, &zerotime);
> +       ceph_encode_timespec64(p, &arg->btime);
>         p += sizeof(struct ceph_timespec);
>         ceph_encode_64(&p, 0);
>
> @@ -1379,6 +1378,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>         arg.mtime = inode->i_mtime;
>         arg.atime = inode->i_atime;
>         arg.ctime = inode->i_ctime;
> +       arg.btime = ci->i_btime;
>
>         arg.op = op;
>         arg.caps = cap->implemented;
> @@ -1438,6 +1438,7 @@ static inline int __send_flush_snap(struct inode *inode,
>         arg.atime = capsnap->atime;
>         arg.mtime = capsnap->mtime;
>         arg.ctime = capsnap->ctime;
> +       arg.btime = capsnap->btime;
>
>         arg.op = CEPH_CAP_OP_FLUSHSNAP;
>         arg.caps = capsnap->issued;
> @@ -3044,6 +3045,7 @@ struct cap_extra_info {
>         u64 nsubdirs;
>         /* currently issued */
>         int issued;
> +       struct timespec64 btime;
>  };
>
>  /*
> @@ -3130,6 +3132,7 @@ static void handle_cap_grant(struct inode *inode,
>                 inode->i_mode = le32_to_cpu(grant->mode);
>                 inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
>                 inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
> +               ci->i_btime = extra_info->btime;
may btime change?  If not, we don't need to update it.

>                 dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
>                      from_kuid(&init_user_ns, inode->i_uid),
>                      from_kgid(&init_user_ns, inode->i_gid));
> @@ -3851,17 +3854,20 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>                 }
>         }
>
> -       if (msg_version >= 11) {
> +       if (msg_version >= 9) {
>                 struct ceph_timespec *btime;
>                 u64 change_attr;
> -               u32 flags;
>
> -               /* version >= 9 */
>                 if (p + sizeof(*btime) > end)
>                         goto bad;
>                 btime = p;
> +               ceph_decode_timespec64(&extra_info.btime, btime);
>                 p += sizeof(*btime);
>                 ceph_decode_64_safe(&p, end, change_attr, bad);
> +       }
> +
> +       if (msg_version >= 11) {
> +               u32 flags;
>                 /* version >= 10 */
>                 ceph_decode_32_safe(&p, end, flags, bad);
>                 /* version >= 11 */
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 72c6c022f02b..854308e13f12 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -606,6 +606,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>         capsnap->mtime = inode->i_mtime;
>         capsnap->atime = inode->i_atime;
>         capsnap->ctime = inode->i_ctime;
> +       capsnap->btime = ci->i_btime;
>         capsnap->time_warp_seq = ci->i_time_warp_seq;
>         capsnap->truncate_size = ci->i_truncate_size;
>         capsnap->truncate_seq = ci->i_truncate_seq;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3dd9d467bb80..c3cb942e08b0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -197,7 +197,7 @@ struct ceph_cap_snap {
>         u64 xattr_version;
>
>         u64 size;
> -       struct timespec64 mtime, atime, ctime;
> +       struct timespec64 mtime, atime, ctime, btime;
>         u64 time_warp_seq;
>         u64 truncate_size;
>         u32 truncate_seq;
> --
> 2.21.0
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
