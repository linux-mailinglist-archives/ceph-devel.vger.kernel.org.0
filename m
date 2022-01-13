Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEF548D297
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 08:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiAMHFn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 02:05:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbiAMHFn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 02:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642057542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VbDn8ReGX1VkwqqLlQO0SS47xAoEHJPU3zsIVO9wN40=;
        b=SW1G85h67WlYLv0xpve3nZiFSh2Uqgs0Eu8DIlJZsK7raCJasnlA/E/3Bhi/E4fr8WL/ai
        /H0Q+aw89LK2hsETEiVYFcx8ctd0z7A2g1YIoFjUFkJRTZcFfl0nPFCWkBg6G3yF2q4Tsd
        FA1Ny8GKMkSBRrybvn0JXAI9ybXIyOs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-CO1aU3WKOuSALlsTZXu42Q-1; Thu, 13 Jan 2022 02:05:40 -0500
X-MC-Unique: CO1aU3WKOuSALlsTZXu42Q-1
Received: by mail-ed1-f69.google.com with SMTP id y18-20020a056402271200b003fa16a5debcso4473150edd.14
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jan 2022 23:05:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbDn8ReGX1VkwqqLlQO0SS47xAoEHJPU3zsIVO9wN40=;
        b=ps7FEzeJFMZgwVIc48b2JebyAYowN1ZZPLhlNtaH7AGIo933SR+FO9BHMId8qkiTIc
         bPV90VzsukOt9lIVN7BmvR1g0rSlrb7vG/NKqF8/Aglc9xN8CgHjtjbLPEs9xQVurusM
         3RaFHAzl7iCsXernCGHs5a26A5TAvFCS8xItnrHaTzuIiUvrKZDYFzhTlHVV6RlZjEfA
         hsRY6ZfWOSIGNyO4vT4+neZjnPe+BrroHQHMKpryXyGzxfonHEPNEJEFQYG187ytK1Wp
         Q73oP39O2YY2xFjTRBcHpZXy8Yog3PM807rtWzQMzWKQlFdHwd3rXU7GTFF+i6niaoHn
         RARg==
X-Gm-Message-State: AOAM531XUA2WGWtyrJiDQMBaujy0s96nw/659xriz/2myj6rRVx5jGQ6
        Cl462JJ1k+HM0+5y9SQqg5B+Wrk0j+xRukFWDUjxp/3A9KuiEJ2EjvaFPoFtGXYygkgFYg087VL
        SXajHR3AWr97soDP1SdOFsepoUszw14Vryvau6w==
X-Received: by 2002:a05:6402:11ca:: with SMTP id j10mr3038095edw.169.1642057539476;
        Wed, 12 Jan 2022 23:05:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxM2nAubiiRfMPTSj0eCgpCGTTP9eP8NMd96z82ZhcXxhtfk5ERM7PRAB7UaTJ5N1trOaFAqcjCoSGLep3r544=
X-Received: by 2002:a05:6402:11ca:: with SMTP id j10mr3038077edw.169.1642057539238;
 Wed, 12 Jan 2022 23:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20220112042904.8557-1-xiubli@redhat.com>
In-Reply-To: <20220112042904.8557-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 13 Jan 2022 12:35:02 +0530
Message-ID: <CACPzV1kvzEwoqdMQVHF8MSWOBG9_utwSpeCiJbEbTj3L2vZJog@mail.gmail.com>
Subject: Re: [PATCH] ceph: put the requests/sessions when it fails to alloc memory
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 12, 2022 at 9:59 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When failing to allocate the sessions memory we should make sure
> the req1 and req2 and the sessions get put. And also in case the
> max_sessions decreased so when kreallocate the new memory some
> sessions maybe missed being put.
>
> And if the max_sessions is 0 krealloc will return ZERO_SIZE_PTR,
> which will lead to a distinct access fault.
>
> URL: https://tracker.ceph.com/issues/53819
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
> ---
>  fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 18 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 944b18b4e217..5c2719f66f62 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2276,6 +2276,7 @@ static int unsafe_request_wait(struct inode *inode)
>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> +       unsigned int max_sessions;
>         int ret, err = 0;
>
>         spin_lock(&ci->i_unsafe_lock);
> @@ -2293,37 +2294,45 @@ static int unsafe_request_wait(struct inode *inode)
>         }
>         spin_unlock(&ci->i_unsafe_lock);
>
> +       /*
> +        * The mdsc->max_sessions is unlikely to be changed
> +        * mostly, here we will retry it by reallocating the
> +        * sessions arrary memory to get rid of the mdsc->mutex
> +        * lock.
> +        */
> +retry:
> +       max_sessions = mdsc->max_sessions;
> +
>         /*
>          * Trigger to flush the journal logs in all the relevant MDSes
>          * manually, or in the worst case we must wait at most 5 seconds
>          * to wait the journal logs to be flushed by the MDSes periodically.
>          */
> -       if (req1 || req2) {
> +       if ((req1 || req2) && likely(max_sessions)) {
>                 struct ceph_mds_session **sessions = NULL;
>                 struct ceph_mds_session *s;
>                 struct ceph_mds_request *req;
> -               unsigned int max;
>                 int i;
>
> -               /*
> -                * The mdsc->max_sessions is unlikely to be changed
> -                * mostly, here we will retry it by reallocating the
> -                * sessions arrary memory to get rid of the mdsc->mutex
> -                * lock.
> -                */

"array"

> -retry:
> -               max = mdsc->max_sessions;
> -               sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
> -               if (!sessions)
> -                       return -ENOMEM;
> +               sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
> +               if (!sessions) {
> +                       err = -ENOMEM;
> +                       goto out;
> +               }
>
>                 spin_lock(&ci->i_unsafe_lock);
>                 if (req1) {
>                         list_for_each_entry(req, &ci->i_unsafe_dirops,
>                                             r_unsafe_dir_item) {
>                                 s = req->r_session;
> -                               if (unlikely(s->s_mds >= max)) {
> +                               if (unlikely(s->s_mds >= max_sessions)) {
>                                         spin_unlock(&ci->i_unsafe_lock);
> +                                       for (i = 0; i < max_sessions; i++) {
> +                                               s = sessions[i];
> +                                               if (s)
> +                                                       ceph_put_mds_session(s);
> +                                       }
> +                                       kfree(sessions);

nit: this cleanup can be a separate function since it gets repeated below.

>                                         goto retry;
>                                 }
>                                 if (!sessions[s->s_mds]) {
> @@ -2336,8 +2345,14 @@ static int unsafe_request_wait(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_iops,
>                                             r_unsafe_target_item) {
>                                 s = req->r_session;
> -                               if (unlikely(s->s_mds >= max)) {
> +                               if (unlikely(s->s_mds >= max_sessions)) {
>                                         spin_unlock(&ci->i_unsafe_lock);
> +                                       for (i = 0; i < max_sessions; i++) {
> +                                               s = sessions[i];
> +                                               if (s)
> +                                                       ceph_put_mds_session(s);
> +                                       }
> +                                       kfree(sessions);
>                                         goto retry;
>                                 }
>                                 if (!sessions[s->s_mds]) {
> @@ -2358,7 +2373,7 @@ static int unsafe_request_wait(struct inode *inode)
>                 spin_unlock(&ci->i_ceph_lock);
>
>                 /* send flush mdlog request to MDSes */
> -               for (i = 0; i < max; i++) {
> +               for (i = 0; i < max_sessions; i++) {
>                         s = sessions[i];
>                         if (s) {
>                                 send_flush_mdlog(s);
> @@ -2375,15 +2390,19 @@ static int unsafe_request_wait(struct inode *inode)
>                                         ceph_timeout_jiffies(req1->r_timeout));
>                 if (ret)
>                         err = -EIO;
> -               ceph_mdsc_put_request(req1);
>         }
>         if (req2) {
>                 ret = !wait_for_completion_timeout(&req2->r_safe_completion,
>                                         ceph_timeout_jiffies(req2->r_timeout));
>                 if (ret)
>                         err = -EIO;
> -               ceph_mdsc_put_request(req2);
>         }
> +
> +out:
> +       if (req1)
> +               ceph_mdsc_put_request(req1);
> +       if (req2)
> +               ceph_mdsc_put_request(req2);
>         return err;
>  }

Looks good.

Reviewed-by: Venky Shankar <vshankar@redhat.com>

>
> --
> 2.27.0
>

-- 
Cheers,
Venky

