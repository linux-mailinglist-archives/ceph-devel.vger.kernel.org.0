Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404FC15BBAE
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 10:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgBMJ3S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 04:29:18 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40288 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgBMJ3S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 04:29:18 -0500
Received: by mail-qk1-f194.google.com with SMTP id b7so5003203qkl.7
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 01:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sWMGdhjHK8fDD0m9tofESOFDO5qkuF1OQ6xnmoCrPkU=;
        b=VmXVY8TAz9PsZ5WghMSYdterye4tqZuVi5U5HhSC0jc6PHcIhHSjX2MOVXlmYHBlwV
         UJAKa/l+PhW132SdmR2AYNTlcnS8ZOeZI3ifcfTpjQp6AoCK/QBXlN2TcLgBmrovEiFt
         nOKiLXfv1YemOkSY+YXln0i+jtbX5kwc67NyUHr9CovtX4S/RjcG3DBCJ5P5/rOhR1Ps
         oYQeqaQWf4yUxS2jR8WKrWdCuhM3kj436szGJkCcPXN0E5LV9Gw09qDOc5c4mBGL8uoy
         MkZK9q9aBxA0CFVwPIAlMX5R/MO63XbKC8Qfvi4F8c6A+m8De/dj+X9eAluUvGC7SpPo
         LTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sWMGdhjHK8fDD0m9tofESOFDO5qkuF1OQ6xnmoCrPkU=;
        b=e8OPsT6FT71snjBkPrHZ8Xg7fVPbIlpzL+bH6U05deEilyBUB0cyi8SqjUgOYrJBE1
         q1K0qZwm92LpFLa73Xp/oHzezp9yLmb512kQ760mO6/gPyrP3rhiuzE0ROCMcFokuKDW
         sKc4sRjPYGnENZyZkgJRA5A6CUg8yxMl3FtVEw08braJjuaO0gEup22MWc2MkK/olJaS
         bjsXOxavweoB2ZCmYs4lJbAojBD+XsIga2bd099SaLE1QffuPm4BpKIpy/J9flV6+een
         PxWXbGbRkltJN5vZ0HOMVSGRidqqJqfu8qHsXE6HzNa0G7W47BC9nSCapaOp+JhmH9rS
         DbNA==
X-Gm-Message-State: APjAAAWsoieYEmhOQBOFMrLG+Ws2NzOdjtwPF9MGiYFNpPkH3YL7ukiq
        rX01l6Sm3Fn2uGdgPcRxmrEWmU54JX0QpwsFoAY=
X-Google-Smtp-Source: APXvYqy2ty6I3y36L8BKIJBw/hiZ5WKvQPnjJMFSxzfnwvPlrWkRDanQuFBekP/cWKQrjOs/bRZppFVkmM0WbZyz/wk=
X-Received: by 2002:a05:620a:1530:: with SMTP id n16mr11386380qkk.394.1581586157619;
 Thu, 13 Feb 2020 01:29:17 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org> <20200212172729.260752-2-jlayton@kernel.org>
In-Reply-To: <20200212172729.260752-2-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 17:29:06 +0800
Message-ID: <CAAM7YA==_fYLnaVjhs51=T5Ju+t8EtDSQEpUTYKko620h86=-A@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] ceph: add flag to designate that a request is asynchronous
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> ...and ensure that such requests are never queued. The MDS has need to
> know that a request is asynchronous so add flags and proper
> infrastructure for that.
>
> Also, delegated inode numbers and directory caps are associated with the
> session, so ensure that async requests are always transmitted on the
> first attempt and are never queued to wait for session reestablishment.
>
> If it does end up looking like we'll need to queue the request, then
> have it return -EJUKEBOX so the caller can reattempt with a synchronous
> request.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c              |  1 +
>  fs/ceph/mds_client.c         | 11 +++++++++++
>  fs/ceph/mds_client.h         |  1 +
>  include/linux/ceph/ceph_fs.h |  5 +++--
>  4 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 094b8fc37787..9869ec101e88 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1311,6 +1311,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>                 err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
>                                 session,
>                                 (!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> +                                !test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) &&
>                                  rinfo->head->result == 0) ?  req->r_fmode : -1,
>                                 &req->r_caps_reservation);
>                 if (err < 0) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2980e57ca7b9..9f2aeb6908b2 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2527,6 +2527,8 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
>         rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
>         if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
>                 flags |= CEPH_MDS_FLAG_REPLAY;
> +       if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
> +               flags |= CEPH_MDS_FLAG_ASYNC;
>         if (req->r_parent)
>                 flags |= CEPH_MDS_FLAG_WANT_DENTRY;
>         rhead->flags = cpu_to_le32(flags);
> @@ -2634,6 +2636,15 @@ static void __do_request(struct ceph_mds_client *mdsc,
>                         err = -EACCES;
>                         goto out_session;
>                 }
> +               /*
> +                * We cannot queue async requests since the caps and delegated
> +                * inodes are bound to the session. Just return -EJUKEBOX and
> +                * let the caller retry a sync request in that case.
> +                */
> +               if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
> +                       err = -EJUKEBOX;
> +                       goto out_session;
> +               }

the code near __choose_mds also can queue request


>                 if (session->s_state == CEPH_MDS_SESSION_NEW ||
>                     session->s_state == CEPH_MDS_SESSION_CLOSING) {
>                         __open_session(mdsc, session);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 27a7446e10d3..0327974d0763 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -255,6 +255,7 @@ struct ceph_mds_request {
>  #define CEPH_MDS_R_GOT_RESULT          (5) /* got a result */
>  #define CEPH_MDS_R_DID_PREPOPULATE     (6) /* prepopulated readdir */
>  #define CEPH_MDS_R_PARENT_LOCKED       (7) /* is r_parent->i_rwsem wlocked? */
> +#define CEPH_MDS_R_ASYNC               (8) /* async request */
>         unsigned long   r_req_flags;
>
>         struct mutex r_fill_mutex;
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index cb21c5cf12c3..9f747a1b8788 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -444,8 +444,9 @@ union ceph_mds_request_args {
>         } __attribute__ ((packed)) lookupino;
>  } __attribute__ ((packed));
>
> -#define CEPH_MDS_FLAG_REPLAY        1  /* this is a replayed op */
> -#define CEPH_MDS_FLAG_WANT_DENTRY   2  /* want dentry in reply */
> +#define CEPH_MDS_FLAG_REPLAY           1 /* this is a replayed op */
> +#define CEPH_MDS_FLAG_WANT_DENTRY      2 /* want dentry in reply */
> +#define CEPH_MDS_FLAG_ASYNC            4 /* request is asynchronous */
>
>  struct ceph_mds_request_head {
>         __le64 oldest_client_tid;
> --
> 2.24.1
>
