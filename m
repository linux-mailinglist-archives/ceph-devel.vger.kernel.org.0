Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C013B7062
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 12:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhF2KJ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 06:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhF2KJ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 06:09:59 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF9FC061574
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 03:07:31 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id s18so2396436ilt.10
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7TxOb5r1PkTE6sG+uwMCaepk8NMCALXo5Deo4DVqYdg=;
        b=OdSt2RfQSMKDTGHWF+QLn1VWzT/XUpD7SfPoALTxIKfJpe94FftsnZqjYpmOnO6Ye1
         TsA3KKZDIBbKx7Bd79Etl9l3gYDNBzE1zp0IBsVfQEqHa5zFPSYqB8jJ52Ymf74aJ4P0
         iuA3jzocp7/1uT8EIE9gtWqAsrhpYLhfKxVJwjFkEBf1qikwdOWLNaPkk2hqdvlVD73s
         d5k1MViHwpSEyr9uqdAsCsbtxtnLdsTeFQITVTI5UdPvY2JK7+Y42Cq6fErsivnVBOyY
         X50AJTxE/L/lgBDnbo8SFTlgTomYnPcP9ScOGsZn+msef67Kf3V7LLN8+vndDFPYZTy+
         kmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7TxOb5r1PkTE6sG+uwMCaepk8NMCALXo5Deo4DVqYdg=;
        b=uSCJq6fvuU3c9AIYKgY/PMwHPcz3FlUiohLD/ycVRcAdsRGkqdOST/imjuZQWbOPSC
         AgbDM0mGPlpUDanJ6LGh808Vpq6AxetiYE53eBt+QtcuazGk6+BvtSpvsZh67mvZn3IK
         9vU/atzE3IovfeAV4ZnfcDUVl0s/J5W1anQXRDNukr2o6ANOsVm82jS0cMcDXy0jf4zC
         NQYWHSxUOAP1i1IqWmC06XR1ut+644+uSB5pyUP/RfgZwXU+tnd9WbGTTDW+TZWISmGh
         OjyuJB6/fwU0rf/j+zwdmte9jUNj9UA9womq7dRwVQ/ms2KgxVO+KhHzAgk33bYaBaIc
         uGFQ==
X-Gm-Message-State: AOAM533fQsCpyMH75BWzn5GDNUi+W9/Y8RmHGMG03no3EbjxHqHxgxA+
        NXQMsDiibuGo3Ik9aHvI+wRz08BHu1njkz8RRhkxyqW/jj81vg==
X-Google-Smtp-Source: ABdhPJwUxX45yb222GyI6nNfRADMGkEupIUnbm0ffz4QMbzy7SnW9gi8PEZk/LAnxhax25OYXfwduguis0jhfazeOl4=
X-Received: by 2002:a92:290f:: with SMTP id l15mr21682836ilg.220.1624961251294;
 Tue, 29 Jun 2021 03:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue> <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue> <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue> <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
 <391efdae70644b71844fe6fa3dceea13@nl.team.blue> <2d37c87eb42d4bc2a99184f6bffce8a2@nl.team.blue>
In-Reply-To: <2d37c87eb42d4bc2a99184f6bffce8a2@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 29 Jun 2021 12:07:12 +0200
Message-ID: <CAOi1vP-dT=1C2SqcMxAR1NWrcHUE1K-F6M1BpBWb7pVCDhS7Og@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 10:39 AM Robin Geuze <robin.geuze@nl.team.blue> wrote:
>
> Hey Ilya,
>
> Do you have any idea on the cause of this bug yet? I tried to dig around a bit myself in the source, but the logic around this locking is very complex, so I couldn't figure out where the problem is.

I do.  The proper fix would indeed be large and not backportable but
I have a workaround in mind that should be simple enough to backport
all the way to 5.4.  The trick is making sure that the workaround is
fine from the exclusive lock protocol POV.

I'll try to flesh it out by the end of this week and report back
early next week.

Thanks,

                Ilya
