Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5F95C107
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 18:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfGAQVw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 12:21:52 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:45053 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfGAQVv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 12:21:51 -0400
Received: by mail-qt1-f169.google.com with SMTP id x47so15233940qtk.11
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jul 2019 09:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wReeoaRie2JUZxmVz6kyykzosUA4VwPgA0J11kw6z/Q=;
        b=nF7Ts/aBG4AYT2FmBYfcnpE4PbJFpbzbZlLBbvMvzyZskluhfRmiYUUnGWaLeJLEDD
         dBJKvpneAqtmEx1AWmYOxOdIL3BoCJf+8gaC1en8whWaEgcLRXDXrMGo7A2KW0mGyCLC
         IUrxytN48m7Qy9bEqQb+N0ChtpEvdPhyiN+4IMS6ZOPL8mPhXlHf7hTujeZANPBvx7aC
         WAKnDuInk9YwFtcRv7+hytZe7bYUMzucD5uirI21NKsrauvquq2iueJeezhFPbMkQAYG
         Fxsb+RDMr0otz6bBTy9/86k3avhh2iNY8fsAc2NltnFmw+07LzsKVgWPHGFAqXTnouo4
         XF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wReeoaRie2JUZxmVz6kyykzosUA4VwPgA0J11kw6z/Q=;
        b=Tgx1nZHEjqUH/IAEPFvYRKPzacCdYxhN+D/CCkhdaj94HtGXF1lxqhwVUollKB3gh5
         imLQzdgK0ykRo2rD4H09+XVfPQgjdbxYwaIrZExPc8zqUY4CIOhQzgOaMieNDuWqSci2
         5wFtUIxcGh/04QQAIF9rvnk2bUHPmNFYIvyK1IxljZnq3nc5XTCrE6C1mw4JC5yFOsaA
         W95CNRRAph87DvQasQLNbjagY0EPd592SJpeDUOu/EY4/eEVgAAzL+446HZ4OK0US8AR
         r6zxERl4VnP5jHVurLaoA3D5vHkchEKCau+l2TiGpm3dx5GB8W5/MRK83CGgbpjFmBKN
         HAgQ==
X-Gm-Message-State: APjAAAUkQujGzn5J1Ae0DdpvMhETKOqdBtEiDRViO13ZaZZ/l+EegCj+
        jctsaTxm63dKfO4FvERJFdUj0cDK3Qs/8yVNCM73fwRB
X-Google-Smtp-Source: APXvYqxsotL8ESSjbUdAJDgHeMKl+PE4jYT7IUnndfLQ99A2eud4/XJw7EslpqjpADXOPvDa7Y5LL0TXL/KtwKofHnE=
X-Received: by 2002:aed:3ac1:: with SMTP id o59mr21142550qte.260.1561998106682;
 Mon, 01 Jul 2019 09:21:46 -0700 (PDT)
MIME-Version: 1.0
From:   huang jun <hjwsm1989@gmail.com>
Date:   Tue, 2 Jul 2019 00:21:35 +0800
Message-ID: <CABAwU-btvFQypUTwjgGfS0L2iPdzOBdKFUYSLK_TY-_Sq+96Dw@mail.gmail.com>
Subject: how to do cross compile ceph to aarch64 on x86
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, all
I'm bit curious whether ceph support cross compile to aarch64 on x86,
any documents introduce about this?
