Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACE62E49D
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfE2SjY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 14:39:24 -0400
Received: from mail-it1-f175.google.com ([209.85.166.175]:36200 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfE2SjX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 14:39:23 -0400
Received: by mail-it1-f175.google.com with SMTP id e184so5252666ite.1
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 11:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yD4oGFZpaySYuWFuawJG9IVFwVfxUYwsmP0JQroreyA=;
        b=FCoa7nEJ8Nx8RMtCO3wB9Q4akPt0btsBccsO2hhAfn3MmIuqfOj5v2WMMmyOPhogGy
         FilureDGt5boRpnq9yUIF+NXChfFH2qZCHtIf0Rz4/VvcCiXJuKha6Ai4c7Th359veLc
         W1QnEqJ0zQwP+OWwdUtpOsqYom1svh3dOZA7ZVW+57i4M8ual4LLBwERw+F8fQH+0ZsY
         SCFIT+PvauZdpiCd/jlyJXBf2Tq97zid1Zpchl78RfG5d1Ib2mncNfut6mzA7RDn5Z2F
         xrHWtYd1J/f9jvqGN051iepe0rUk+V6R09zU6qMbyj0o6lL7cxwLltL0MUjZqMdoI5Uc
         YfOA==
X-Gm-Message-State: APjAAAXfOH4r7Dlbq40M0Ytn5vXGyI164s4RxxkIsoSl4HONMHYafX+v
        191jRsbPIAtHdwasB6qIuZw3qPDKcmC84yXk+O5/OH8T
X-Google-Smtp-Source: APXvYqzAGXvv53XmONpUg6MGYm5wnW7g7gVxDgJ1Uk1GEiNGm95zGXcP3lY9R1y2svr75lJwP4vGtFoMUpdNhgYML5Y=
X-Received: by 2002:a24:104a:: with SMTP id 71mr8546966ity.76.1559155162656;
 Wed, 29 May 2019 11:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAE63xUOQPizvSWe4YL_2fiSJ5uYxMdOTz1nqL9QizNGxwyyWQQ@mail.gmail.com>
In-Reply-To: <CAE63xUOQPizvSWe4YL_2fiSJ5uYxMdOTz1nqL9QizNGxwyyWQQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 29 May 2019 11:38:43 -0700
Message-ID: <CAJ4mKGZ4bDcJ+TeBSRfcynpTXWjdwuXqo=t6fxmaynbJPC10HA@mail.gmail.com>
Subject: Re: fully encrypted ceph
To:     Ugis <ugis22@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If you're running Nautilus you can enable the new messenger encryption
option. That's marked experimental right now but has been stable in
testing so that flag will be removed in the next point release or two.

Not sure about setting up Ceph-volume with locally-stored keys; partly
we just assume your monitors are "farther away" from the OSD drives so
even if the keys are transmitted unencrypted that's more secure
against practical attacks...
-Greg

On Wed, May 29, 2019 at 11:28 AM Ugis <ugis22@gmail.com> wrote:
>
> Hi,
>
> What are current options to set up fully encrypted ceph cluster(data
> encrypted in transit & at rest)?
>
> From what I have gathered:
> option: ceph OSDs with dmcrypt and keys stored in monitors - this
> seems not secure because keys travel from monitors to OSDs unencrypted
> by default.
>
> workarounds would be:
> - best:to use OSDs on luks crypt devices and unlock luks locally but
> somehow ceph-volume refuses to create OSD on /dev/mapper/..crypt
> device - why that?
> - not avaialable: to store OSD dmcrypt keys in TANG server and use
> clevis to retrieve keys.
> - viable but unconvenient: create VPN between osds and mons
>
> What could be other suggestions to set up fully encrypted ceph?
>
> Best regards,
> Ugis
