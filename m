Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6F224E4D
	for <lists+ceph-devel@lfdr.de>; Sun, 19 Jul 2020 01:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgGRXrA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Jul 2020 19:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgGRXq7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 18 Jul 2020 19:46:59 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A698FC0619D2
        for <ceph-devel@vger.kernel.org>; Sat, 18 Jul 2020 16:46:59 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i4so13995046iov.11
        for <ceph-devel@vger.kernel.org>; Sat, 18 Jul 2020 16:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VgtBleyXTev+cuzCcMkuuZZ182hIQd2Wnzam9Ewu2+w=;
        b=GUMQw8NghvCN4vkdqPmWKAnJ9pB7bF1xaHeoHcN+SnughFUDZw9bksIeXfNHi7WLXR
         +J2B/uTMHoGjAP8yi9rKmWinWi90LGLilTr113H9d2lNo90iKkbrLVXboO3hYzrMoM+v
         qE9Dx6vqNQGrO1yggW3odL4WMdKlcJBFATfPQEnhP3XPPD7SvYUGQ7KCDNkddpnSWVlf
         neUQ71c9UHR95Xt8kpg6Q/JWOmMdzsFd9P3/t9YuX5lUUBm8TON/vDmwNXv/Pkktco/i
         1Uh7jRhMRLUndt3G3v8tpS+a2ZjofuUHwNGp37ZKzWlVfIOpUGX5glNRmwyIVySGQXHq
         QSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VgtBleyXTev+cuzCcMkuuZZ182hIQd2Wnzam9Ewu2+w=;
        b=TM4xkkwY2iaRWd9WVoEUDdQUPIu0AoNnhIVzNd0zDjZNgpiQxjyPLzzItkGkKjeRZT
         4fJVQlBexda8X08IXQ46nQOarhHpH1P78AmNMa25j2usaaiCK9GAYCv6SAivwP4RG+99
         vE6zgTDRRK7c0DiFDSnkfLoyr2VEIlUj5akM1STUrJSX0jUId0olZ3g6gP5nyHL37bS7
         tm8AhFQ8rD9Pi0BXIRbUL8x4YNLRFxCU01aE8nT+aZVUQSuEj6727N1Uli0Oghi8Vhis
         9t1Guam1N3qbeceHLRFxyIKwINK9dEiimnK3TiMelogPODFJagZVHwQKo56ZLZvsZjHO
         iw+g==
X-Gm-Message-State: AOAM530LokMEF1AjVHDgfAzVUmsR8C2gD8Myd5TMv63uWmK0p8fxxi8n
        ZjdWFgGGPSDBmHofV2/za+mrR6GzMD8YSPfI86IItjt0
X-Google-Smtp-Source: ABdhPJyVTZMhsO2k7hqJX2Qp/ivSTL8w13ceVat1SsUwVKWp75Rx+8Hj6no5bHWo2HiT9XMrRgADeL5pA9+rkhINsI4=
X-Received: by 2002:a5e:d80e:: with SMTP id l14mr11144645iok.65.1595116018674;
 Sat, 18 Jul 2020 16:46:58 -0700 (PDT)
MIME-Version: 1.0
From:   "Rob Tilley Jr." <rftilleyjr@gmail.com>
Date:   Sat, 18 Jul 2020 19:46:23 -0400
Message-ID: <CAEDtz9YeQOACR9rDERK7kBsb1j0e80SB1k_p+LAAjKMyxez==A@mail.gmail.com>
Subject: Crimson & Seastore
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All,

I am really looking forward to using Crimson with Seastore. Do you
have any ideas on when this will become "stable" enough to use in a
production environment? Even if it is in beta, I'd like to implement
it in a production environment if it's stable, if future releases will
allow for in-place upgrade. Any information on this would be greatly
appreciated.

Thanks in advance for your assistance,
Rob Tilley
