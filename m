Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC639299
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 18:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfFGQ5g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 12:57:36 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:42629 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbfFGQ5f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jun 2019 12:57:35 -0400
Received: by mail-io1-f44.google.com with SMTP id u19so1931484ior.9
        for <ceph-devel@vger.kernel.org>; Fri, 07 Jun 2019 09:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZUBQAY2NKLcWV7ykeBDlWj5fofo9UbVtWDtMbHVbK4=;
        b=e71XXaUrMCmyTV3edC18FxKU8pGXJreaNCtXRnGtOOeTvZgI5B9CtxZCjmkdlSoJDX
         Cx6vkWG8FfwKXxY0FrOoMGUA1178YVyGopXqAUFw++gAJPAV8B0whbmOx3JVTxkpxvwS
         y7GCFTyVDuqiXbM/o6B2q0RVUK0Qkvws/kiOYjBeNUYNRI8VL4T9R7wx+aXMXMF4oQ8A
         Psf1HiCaslkvfaXokeAXzNXotPYoxVRwAfVpXOzX9tVf69I12pDSzamlM8RCgLwIFQ4/
         dXq/4E6vv29AUrWKAZ25H8eHH0BCKov3MSx0IL0U4beIWMEx6dGDnXesvO686qz3t5Wb
         AJ0w==
X-Gm-Message-State: APjAAAUcq63IVvxPbGoNJdjHQaJ8yHYIoVvSxoPedwkg2mk9UEPnqydb
        usdljLh44lWdyvEAR20YxgQr/sPNAYtnjvaMYw2dzQ==
X-Google-Smtp-Source: APXvYqxHVm3C5XPz/ngFMM100/gC4WsDEeBgGwoJHu9vwaSJ1OCmlx1IQkPgqCA7t7599JkG1xfYhjIzhX0Gi0Ao63c=
X-Received: by 2002:a6b:6012:: with SMTP id r18mr11632737iog.241.1559926654959;
 Fri, 07 Jun 2019 09:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <ae0d1372-7021-baac-3743-5122e0397d9b@redhat.com>
In-Reply-To: <ae0d1372-7021-baac-3743-5122e0397d9b@redhat.com>
From:   Mike Perez <miperez@redhat.com>
Date:   Fri, 7 Jun 2019 09:57:23 -0700
Message-ID: <CAFFUGJdVQf3e9TupdbCTR5OoN368N=WtFQuRhrp=Rz_f0TU3ow@mail.gmail.com>
Subject: Re: 06/06/2019 perf meeting is on!
To:     Mark Nelson <mnelson@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

And here is the recording:

https://youtu.be/us8X3tGuBOo

--
Mike Perez (thingee)

On Thu, Jun 6, 2019 at 7:47 AM Mark Nelson <mnelson@redhat.com> wrote:
>
> Hi Folks,
>
>
> Welcome back from Cephalocon!  Perf meeting is on in ~15 minutes.  I'm
> sending this both to the old and the new ceph development lists, but in
> the future these emails will only be sent to the new dev@ceph.io list so
> please remember to register!
>
> Today we will talk a bit about some of the discussion that happened at
> cephalocon around the new community performance hardware, plans for
> incerta, Jenkins performance testing, autotuning, and trocksdb.
>
>
>
> Etherpad:
>
> https://pad.ceph.com/p/performance_weekly
>
> Bluejeans:
>
> https://bluejeans.com/908675367
>
>
> Thanks,
>
> Mark
>
>
>
>
>
>
>
>
>
