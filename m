Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AC739A2A0
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhFCN7f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 09:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhFCN7e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Jun 2021 09:59:34 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7ACC06174A
        for <ceph-devel@vger.kernel.org>; Thu,  3 Jun 2021 06:57:50 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e7so5617367ils.3
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 06:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WFX+5/vZJoVisD2XVDSG+YAG8LW6JJC496EY7IklHE=;
        b=oQzyO8svTWGOHiFKEJ/O+5xuzRSoDC+B4Ss6P69aheOdtjARWrPt+OSgCI1xQXSKtm
         dLvGW9AlDPTS0Fks/NJSIzh9PnDyROSsLPtOtdRBJWV7Qrdgt+YdboZGT44NRtog3cnC
         tm+XChq/atm5+VCl0jGQc/QnLWR5LdcRan81tC33Kcn1k/aBlO2hEUbXWaOEMWm3fwY9
         U2ojez9LFpvNRAe8HD/070uiC0AFLCkYsHjAwDuB61ZBzx9fx/wktIewR5Up3Z1NG/U7
         z13GAVwW4sFaSoP+9eMXieBLBP3YACqN2bd/gzUQpf8QdES3bzjcXle1s6fBb3SJAiOz
         5VAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WFX+5/vZJoVisD2XVDSG+YAG8LW6JJC496EY7IklHE=;
        b=QKwTuiJKTvzFHIlUxuNYw3XKwYoHQwvt2YiYMfyBNs0GJ7nlCMTD32B6aYN48IUSba
         djGGZYH45Is3vuN4Lrfdf5ztfNb0k2hLV8CcjfN/ZqVnAr4ROnUQraJ8k7FZ+j1Bz06v
         fNDlDRDbhX0AfcEU6NmGthPDzf3DY6L/HHVLsolQvLASqL4IagCdsBd2HFpZUVfFgXpe
         ecsLoAqpo/5KKiU1a1KAdDjFptrBNaJayz3U+/Acwq5MCNFJKO3o4yccMiVmtTDTodJA
         gB74Fnu9FBctm8Pl0d2j9UXybE6SnfrZaKAzpReSt0sz/NrCc4xLmiFSIdBNMXXtLoLe
         iMYw==
X-Gm-Message-State: AOAM532iVJS9Ub/kusI7Fjd8XbLN7Yh6OSSX1DeHGw3RzfgB8jDu9ejb
        lTcLGfflFPNMhucglt2GxgERbkDNmrtaOvDLL/4=
X-Google-Smtp-Source: ABdhPJw3Twac4bwT5RnhpnQ+Rct7i00RVfAhW2F+ZxjmgezPjGkvp5RJusP5Hb5Mg94WMKLwOHk9rb9mo/5rW9B7Phg=
X-Received: by 2002:a05:6e02:eac:: with SMTP id u12mr17911ilj.177.1622728669645;
 Thu, 03 Jun 2021 06:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210603133914.79072-1-jlayton@kernel.org>
In-Reply-To: <20210603133914.79072-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 3 Jun 2021 15:57:52 +0200
Message-ID: <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> error, which is the wrong error code. -EINVAL implies that the user gave
> us a bogus argument to a syscall or something similar. -EIO is more
> descriptive when we hit a decoding error.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/snap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index d07c1c6ac8fb..f8cac2abab3f 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         return 0;
>
>  bad:
> -       err = -EINVAL;
> +       err = -EIO;
>  fail:
>         if (realm && !IS_ERR(realm))
>                 ceph_put_snap_realm(mdsc, realm);

Hi Jeff,

Is this error code propagated anywhere important?

The vast majority of functions that have something to do with decoding
use EINVAL as a default (usually out-of-bounds) error.  I agree that it
is totally ambiguous, but EIO doesn't seem to be any better to me.  If
there is a desire to separate these errors, I think we need to pick
something much more distinctive.

Thanks,

                Ilya
