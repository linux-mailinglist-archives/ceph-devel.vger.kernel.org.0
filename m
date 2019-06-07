Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D6138340
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 06:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfFGEDB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 00:03:01 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:44662 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfFGEDB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jun 2019 00:03:01 -0400
Received: by mail-qt1-f170.google.com with SMTP id x47so761386qtk.11
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 21:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCuKZCCqerpXKHaRSEwjIqGz9caDX8QiW6ojt21WDTE=;
        b=EAWOqKtrnA4X/DtDHeH4aDmhlGfV9VyKqhtL1PppYxZz7C2gHB6eai1EzpAG3NTshS
         QBuGBqN1cyduuCrGb+s643a9CuEKtmMn/mdooNYvib9bzLaP7AfssVk7oY3Q0+dcl3vE
         DuwFZyE+tKtTkmrtiBHmjuNKGuKCWpoi/7/lUQSC48NVCGooKM9zKWMxuVHTzZon4Ea7
         AkDlXmwKMWn37EQlDAB0ASKFBk2JdLi9/UmWVnmWD0L0ZSDHMzfnzmIub6srqYEpjGOM
         oHTQiLHLAEnCthyGPL7ek3Sn5Ny2msVeoEM7Pjksw6FxB/kmSCtwLLOP8m8jnxw5xX84
         gGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCuKZCCqerpXKHaRSEwjIqGz9caDX8QiW6ojt21WDTE=;
        b=PwGn08l+XoJthy0stJY65XWuG3Qkzw6EDM0YyHMPG6ttL5GQcM8ec9ab+hULvlfNqt
         l6lH0nO+NlSmmiuOOpcDFtX5PgP+vPmW6YPBxneY4z+HmNsux0bR2x0n4a12gJ4FcREO
         7SCIQ0uKNByOsEDYfeq3SzNfT98x8JsK9Jvecq5l+AzZdjYEtTGNtipf9zeBpJS8I+ub
         jWyPjh+SFocus7aMWLPjOX0RBHI+zIuFR7nlQgtYoRHXL4KDdDSmUwLfaUQZdW8OFL8J
         OS+oibnudgFlN0mMU7vG5+m7TXstHI5CntSMpyVBKMQ7cuf/FSQ8ik/yxI+gmtZ8cr8i
         uEoA==
X-Gm-Message-State: APjAAAW7w+K2+bamWYxDCeeyzKTAcll/kVH6hpncH7Mw5XA55vivQiIe
        sig7UzP09Ki3fBbktbkPS9vzI0kI6KcVwmNH0I3o2N4U
X-Google-Smtp-Source: APXvYqzz/nRFHGyNwbhysZx/nJpUSVKa+t3xpvkcbapdf4I4Sd6L5yFn6LfBv3m53EzsHcNRyOnGayAjVsfFs/+ytE4=
X-Received: by 2002:aed:3b33:: with SMTP id p48mr37373511qte.143.1559880180025;
 Thu, 06 Jun 2019 21:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal> <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 7 Jun 2019 12:02:48 +0800
Message-ID: <CAAM7YA=XiKgoSMHx_Mi45K6Juf5n6RrfdYrjiQ23m4Qgkuyihw@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 7, 2019 at 5:35 AM Sage Weil <sage@newdream.net> wrote:
>
> On Thu, 6 Jun 2019, Sage Weil wrote:
> > Hi everyone,
> >
> > We'd like to do some planning calls for octopus.  Each call would be 30-60
> > minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard
> > team has a face to face meeting next week in Germany so they should be in
> > good shape.  Sebastian, do we need to schedule something on the
> > orchestrator, or just rely on the existing Monday call?
> >
> > 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll
> > record the calls, of course, and send an email summary after.
> >
> > 2- What day(s):
> >
> >  Tomorrow (Friday Jun 7)
> >  Next week (Jun 10-14... may conflict with dashboard f2f)
>
> It seems SUSE's storage team offsite runs through tomorrow, and Monday is
> a holiday in Germany, so let's wait until next week.
>
> How about:
>
> Tue Jun 11:
>   1500 UTC  Orchestrator (Sebastian is already planning a call)
>   1600 UTC  RADOS
> Wed Jun 12:
>   1500 UTC  RBD
>   1600 UTC  RGW
> Thu Jun 13:
>   1600 UTC  CephFS
>

+1

> ?
> sage
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
