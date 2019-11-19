Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558091023B1
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfKSL6e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 06:58:34 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33684 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSL6d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 06:58:33 -0500
Received: by mail-il1-f193.google.com with SMTP id m5so19388615ilq.0
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2019 03:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nlRLyURN36qolCcp/IUK8Fpx2um4fB8KxP76/SYu/Do=;
        b=AiuvBT6vXO0+7HGI152H47HxUUz0BhNf7sDHcUNVnptEpYqHRxEYOtLfBV/uzd9hrf
         oIgBBNk1kPgTvj+4QIgVnbW/Hki3I9+faRXQqGICIcMZTuTWcKUcWV1dr2mOdtmofzQT
         4lkdbCLx2DDnvuYIaEZWGhR+/XLSQcifs7k1TT4WYYgs1S0T0fdc59BWAH7bCfy9iFhK
         uBFvVTJX1p23JxZ5qHuy6QGb33N19qrerdCT45S9XXKves+kxvjb4GAYQWyj1mgDEQT2
         Pex/uEnBu0xVULXI4fE3rioyGzS6ac14leCVMtYe7h8t4hdiHszusSCLhmTV9FHpuP4h
         ox5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nlRLyURN36qolCcp/IUK8Fpx2um4fB8KxP76/SYu/Do=;
        b=hsUjkprj30oi+xkRG2VnveOKbyCbLcnEmKe1c25onH+u09qAgUvnu/5lC2h6T7Klzg
         Zw3LhE75da7u8WZLGQ/rxtuglqcgt6XfLM5xfs6ehDfuqXHMtsH0YAmYpbT0HGcd5UQj
         E08h78/XQDmZvCCb6Effujz1XuAbjEcGDRpBwCe4wFqLoOoJT3NXgWOAD+DBDs5FgDlh
         3/yK6A5pDhBDLBEHOWx7XETaBNbMn358SYTKVsAfa8yfckN6bdJA+Ib26yeJaL+KDdqg
         Jo986wrkZ9skZCb6ib+mj5Px/FH5BrhraMRoJvaFF+WKBcqKaU9oNIuAZoVIURxY3Hb3
         EAbA==
X-Gm-Message-State: APjAAAXValjkANh/Kq2aXGdCUP0TGgNRHSR7Bj9k2h64BQanVMtU19Qb
        vfmT1dK7fyYr1QCZCF2yRvwvTQFdkaUndNFucOs=
X-Google-Smtp-Source: APXvYqwv9CjsbaEImYmo1jOOWE4mMEjFURnazC6AySs8fwN8tXu9aJ32dnBUArjI5SIwAFWjRFyr4RR2oaOUNjiJGxo=
X-Received: by 2002:a92:b656:: with SMTP id s83mr20850152ili.282.1574164711088;
 Tue, 19 Nov 2019 03:58:31 -0800 (PST)
MIME-Version: 1.0
References: <20191118133816.3963-1-idryomov@gmail.com> <5DD3ACD6.6040009@easystack.cn>
In-Reply-To: <5DD3ACD6.6040009@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Nov 2019 12:59:02 +0100
Message-ID: <CAOi1vP8xERUXtoh7sGUZDR6kRMKBVYx_6uofzA855OPR3Ar61A@mail.gmail.com>
Subject: Re: [PATCH 0/9] wip-krbd-readonly
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jason Dillaman <jdillama@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 9:50 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
> Hi Ilya,
>
> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> > Hello,
> >
> > This series makes read-only mappings compatible with read-only caps:
> > we no longer establish a watch,
>
> Although this is true in userspace librbd, I think that's wired: when
> there is someone is reading this image, it can be removed. And the
> reader will get all zero for later reads.
>
> What about register a watcher but always ack for notifications? Then
> we can prevent removing from image being reading.

We can't register a watch because it is a write operation on the OSD
and we want read-only mappings to be usable with read-only OSD caps:

  $ ceph auth add client.ro ... osd 'profile rbd-read-only'
  $ sudo rbd map --user ro -o ro ...

Further, while returning zeros if an image or a snapshot is removed is
bad, a watch isn't a good solution.  It can be lost, and even when it's
there it's still racy.  See the description of patch 7.

Thanks,

                Ilya
