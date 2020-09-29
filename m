Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8819C27BF7D
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 10:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgI2Ibk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 04:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgI2Ibj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 04:31:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BFAC061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:31:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so3949906ioo.1
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UNII9VM+c23QSTYB0mbw15LFUEx40Xcj/AQ8zdbcIos=;
        b=ItVIYQkM9eUV2FoRe1qIE7XHzTlwmjrBp/xwKL+2my6cyH36wQVtP4NI2wbQXKa81r
         X9uOjHQdH5CWP0dLrj1/5qSRiK9qaavrFKKcXPCFXPLJs7RtiyZoPhoSuBFftwd+ecNB
         4G5/twUOpg6kw0Lav3g5UDwpo04e31J2IDhzec+ar/6Adya6iMWzfBDnSb9rws/+IN3N
         5qaeWvHHW0o/mkJbAin2o9tccRf/wmrnx2vFOn0eHJvwAPy09njrH/JkxGmREVABO46l
         s5kiw8AN+4zDKdmaXzGyjQqroe7XysVRNQL+3JaHfAC+rQHIJfx7liubRUddnIa8CVip
         DuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNII9VM+c23QSTYB0mbw15LFUEx40Xcj/AQ8zdbcIos=;
        b=iT0aesLry7piL9fMlP3Blga4hnvTm81LWm0g/Ng6ZwHMUbKNjWA3MMJAcgfM7ZwVTE
         2Dl3TTOHf1oRO8uvzVlb9fFJ5rT4UhF8u8D+v4C5K+sDWoeVYaBYgxQGY3GSdU7h95kF
         o9SIaFEDuBhexIiWJO3MECTqtW4EM8ax5qF4CnA3jqa8S6KxYqydbIgOLugpyUc6u/VK
         oN+DuGQ2Wa8OD0fqufUMLqBWxttkiUHwv8OJeR2cG+ElLCopfeA3jQXYa0s9vkz69BBW
         t7sT+2o+AVRQmPcDko/8C4+EI55tChuqMvZzEM2i+Np3oUOdw5O0UntLTk/bWFBEvzMc
         KGNQ==
X-Gm-Message-State: AOAM532S2xN4sUUQZJyBSfj8ql4ChFQZhVOWs+5NCR28de7EGX3v6uy6
        9/ALzPbYpWqPg9EpEvRPP/ihKvd+XW3ppg2Cx3Q=
X-Google-Smtp-Source: ABdhPJyZfmYPuG5CtX2BB3Z3GiaTdu72XFeoLoUVkFjZ1/NEcMmAs3Z4I65UaTXw2KBRJKVH+274zZv8F4XY0LunVO8=
X-Received: by 2002:a05:6638:ec5:: with SMTP id q5mr2076729jas.13.1601368298155;
 Tue, 29 Sep 2020 01:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <20200925140851.320673-5-jlayton@kernel.org>
In-Reply-To: <20200925140851.320673-5-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 29 Sep 2020 16:31:27 +0800
Message-ID: <CAAM7YAnNQG7-iV_LcV2Uc1qCsUFeVu1j+G426sG4ruZs=E_n+w@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] ceph: queue request when CLEANRECOVER is set
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Ilya noticed that the first access to a blacklisted mount would often
> get back -EACCES, but then subsequent calls would be OK. The problem is
> in __do_request. If the session is marked as REJECTED, a hard error is
> returned instead of waiting for a new session to come into being.
>
> When the session is REJECTED and the mount was done with
> recover_session=clean, queue the request to the waiting_for_map queue,
> which will be awoken after tearing down the old session.
>
> URL: https://tracker.ceph.com/issues/47385
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fd16db6ecb0a..b07e7adf146f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2819,7 +2819,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
>         if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>             session->s_state != CEPH_MDS_SESSION_HUNG) {
>                 if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
> -                       err = -EACCES;
> +                       if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
> +                               list_add(&req->r_wait, &mdsc->waiting_for_map);
> +                       else
> +                               err = -EACCES;

During recovering session, client drops all dirty caps and abort all
osd requests.  It does not make sense , some operations are waiting,
the others get aborted.

>                         goto out_session;
>                 }
>                 /*
> --
> 2.26.2
>
