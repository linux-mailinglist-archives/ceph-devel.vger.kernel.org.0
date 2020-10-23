Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E19297312
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Oct 2020 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751230AbgJWQCF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Oct 2020 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464844AbgJWQCF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Oct 2020 12:02:05 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2C9C0613CE
        for <ceph-devel@vger.kernel.org>; Fri, 23 Oct 2020 09:02:05 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id x20so1602350qkn.1
        for <ceph-devel@vger.kernel.org>; Fri, 23 Oct 2020 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=68CozXvpMJ4LHIR0/Z3sZMD4HoolVPV59YFWzSadRfQ=;
        b=GeOAngRXdvUWXPSYwFmfNaOE8rx81Zbljwsv3QZ9LCewEPWVGt/m4b8R1hoPbtq0Ds
         YqBG1hat0dP6dw0Bk+PIvs0R/aba4vxX1iVFZUzAPGhoLoC8XQmEPBWLhCAlZGU+8Gta
         cDgrlPkNdcZJ2GfyidWRMZGJXuhz19QN/htxvHnaDl+rjOHhUhsyca5lx8t5RXijIUu4
         fTO/il4L62DN0ur2VY/LorRzyStXD2ebBa3KeS2LGoOSSNBo8kFm4ZHSYJHKDZFny9Te
         4vgLk6X+XGz6tKNTjEfiay28d8xoHDy9xbDSg6Cx0X5MgcidP5Gd7Mypv84ypNYppA91
         rdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=68CozXvpMJ4LHIR0/Z3sZMD4HoolVPV59YFWzSadRfQ=;
        b=c7rw7KyazNfVPDRljfrEhVQNFDOpUnxMQSygyNSbinhJfwTHLcIFpLvyEpVtoPn/xv
         HdR1iRVTcYEn7O5yXEc5xWPsRyWHiwX3KowcFATgMIr741RG9/fHp19YKs8RhkrpV7/S
         aqLS/pN2FjR39jNEJFs+djZZWA7ZqyG0rsZ23VU3vYucwmwQovbMuDxdCSF+95YmYKkF
         kdXPSsKhNLuMw43camN/wuo70xSdfIJGWjKEb/C9LGB6G04bPnslxnPeZ7YDeIyYL00H
         wKG+fcdW4GOLOjD9hZqmR8mOhFv+KblKJXqxQrWaiU3OxlkbGXOKEd035gD8EaRr6Chm
         eAvw==
X-Gm-Message-State: AOAM5314YRa6AwtX57TJPUWdtZ9MBjhQb9aHeTrWGSOc/eexQzYcxc2H
        XWDdHwobs+EH3HnMez1sXmOwvibkNye5hLUM5+sTF0VE73qigg==
X-Google-Smtp-Source: ABdhPJxXHzXRLjDpzsQy7peoCYcp6YLuHn7gIThtxI9EorPo+M3UQETYgl7rN2m0NESS7Qsw1IWQ/bf/nSPKK3W45bc=
X-Received: by 2002:a05:620a:653:: with SMTP id a19mr2857948qka.440.1603468924327;
 Fri, 23 Oct 2020 09:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
 <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
 <CACo-D_DhNDXAyOjJR6W9JYhZP7m9pfbh7q-G1nDMJhHskdtOXQ@mail.gmail.com>
 <CABZ+qqk1ii6sjK4izGb-ReZdUDy4U-7gRj6ywFxzHkpEGuOOHQ@mail.gmail.com>
 <CACo-D_D6abDxhwUY2ZdkFbdwTPduhKbvtK7+7GFL5VWQJbZ7xw@mail.gmail.com>
 <CABZ+qqkB_daQ+yfq+CR3Ye+8t+gv_QuavNWNRJzxP6Og5VKROg@mail.gmail.com>
 <CACo-D_BxGq2-Dq6FahNXPN6rj3BeoKmJuq6j5Nhqzcx74URqHg@mail.gmail.com>
 <CABZ+qqmvn-Yd3ZhPd3q4-RFtqjGgeHLCMwVvjMLJ4fmtxY9-gA@mail.gmail.com>
 <1867678ff367465eb7a6767a62b45764@dtu.dk> <CACo-D_Cjb0TF47ZwYYAXkpnYWN-9eAXtc4K3fGaC=ZLUvHzLRA@mail.gmail.com>
 <CABZ+qqn6FJGU_a7-+Qiqt0YxbfMxN-Bj8X_kcfD+X8P6idRCmA@mail.gmail.com>
 <CACo-D_DCHENXaPntE_T+R7L7yfUVMx9K-KHu40oyd-dKPc_kEg@mail.gmail.com>
 <CABZ+qqkGQKHx=VzvDVjDvG_m7C8PpfbiuRM3+-b5_8yLwgNbFg@mail.gmail.com> <29f9da3105b34397bbaf59471a448077@dtu.dk>
In-Reply-To: <29f9da3105b34397bbaf59471a448077@dtu.dk>
From:   David C <dcsysengineer@gmail.com>
Date:   Fri, 23 Oct 2020 17:01:52 +0100
Message-ID: <CACo-D_BoBo5YdujToR_Tpu9FkUny5B9eTa=vPHHXaHQtPZKv9A@mail.gmail.com>
Subject: Re: [ceph-users] Re: Urgent help needed please - MDS offline
To:     Frank Schilder <frans@dtu.dk>
Cc:     Dan van der Ster <dan@vanderster.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Success!

I remembered I had a server I'd taken out of the cluster to
investigate some issues, that had some good quality 800GB Intel DC
SSDs, dedicated an entire drive to swap, tuned up min_free_kbytes,
added an MDS to that server and let it run. Took 3 - 4 hours but
eventually came back online. It used the 128GB of RAM and about 250GB
of the swap.

Dan, thanks so much for steering me down this path, I would have more
than likely started hacking away at the journal otherwise!

Frank, thanks for pointing me towards that other thread, I used your
min_free_kbytes tip

I now need to consider updating - I wonder if the risk averse CephFS
operator would go for the latest Nautilus or latest Octopus, it used
to be that the newer CephFS code meant the most stable but don't know
if that's still the case.

Thanks, again
David

On Thu, Oct 22, 2020 at 7:06 PM Frank Schilder <frans@dtu.dk> wrote:
>
> The post was titled "mds behind on trimming - replay until memory exhaust=
ed".
>
> > Load up with swap and try the up:replay route.
> > Set the beacon to 100000 until it finishes.
>
> Good point! The MDS will not send beacons for a long time. Same was neces=
sary in the other case.
>
> Good luck!
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Frank Schilder
> AIT Ris=C3=B8 Campus
> Bygning 109, rum S14
