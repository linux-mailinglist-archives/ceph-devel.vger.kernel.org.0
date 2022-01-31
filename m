Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198D74A4B20
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Jan 2022 16:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379957AbiAaP6d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Jan 2022 10:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379956AbiAaP6c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 31 Jan 2022 10:58:32 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E2BC061714
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jan 2022 07:58:32 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso13994078wma.1
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jan 2022 07:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8b+IlI0coAxNrdpm+3ARp/wmpAN2NKJKmTUfBBQ+nMU=;
        b=G1fXKJcxg+48CpAA+Le54VuluJrYtQDzJvcafpXdNO+tyiYZG8/c7cYqQPOJJ2KuhZ
         ldCDPS7BpA7MMNLTUtRXJ90LAgg3ifSR0CwoIP0eFHKc8CQT5N8wZoYuUASaTjR9XB+o
         QyEpWlaIIsy66twfGyEE2ABaFsBNSHDWt3tVSQCFjNgz+cZ+x0uCQVSKlU3A1cI2Q3bU
         OWJXSb1KmH0hi4diV24Lxhs5XQRfTudyMAdrbdpWEG5CMFydHtxjIwo2uIsM5wRdKwB+
         cxdLgMUyxh9+uwvZu1RDC8NMPffavlSvexUoZlFitrZ3+ayQ0l83Urm7J6a2MJxLLbRw
         Y0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8b+IlI0coAxNrdpm+3ARp/wmpAN2NKJKmTUfBBQ+nMU=;
        b=VKIULnZ0HpRlpC+6yhSDF9SC3qBW7QyzQF4MkDqiy4qesghdCqpAIMXJLcxFVt6AlP
         GguUVy1MClmgqB9I2JHnTUv12DQHGgblIC8ga/j18QfJhagUk3ohzj4M3Ra/wPC0LQOK
         VPJFwsEushpA8X97MKAq2wqEAxNISQ/6Gov0qJ4R44QSMJ+Wnssj/3mhdWh9nj+Xu4Bs
         KdrnDLmiTDQXQIC2KscqQX5kCQlciejMCtrY/fnM1eQhU/Ev3JsKwXBFTP3OLZmBWETt
         DlIhtdrYinyRrGbsg+PKJqCY5SOJMFuhWmMTlsQhNTKojJGz+hw9Mm0N04e99jrlNvlq
         oVxw==
X-Gm-Message-State: AOAM5331rTvejXVZ7R3FMWShdR4DXEIBEqF7yE8hX+DDbw45CrCWZZo4
        ezX2a87KDzDSwhSy7yrXV+M77DV4+AI=
X-Google-Smtp-Source: ABdhPJy5r6Arh6vfhllpF8jIU9f8jxRrSCs5o229YFdUedqW0WpC5hzaS/PTv72sbW1u9woEAAyaFw==
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr19655578wmh.57.1643644710546;
        Mon, 31 Jan 2022 07:58:30 -0800 (PST)
Received: from kwango.local (ip-89-102-68-162.net.upcbroadband.cz. [89.102.68.162])
        by smtp.gmail.com with ESMTPSA id m8sm11997075wrn.106.2022.01.31.07.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:58:30 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/2] libceph: rxbounce support
Date:   Mon, 31 Jan 2022 16:58:44 +0100
Message-Id: <20220131155846.32411-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

See the second patch for rationale and explanation.  Tests are added in
https://github.com/ceph/ceph/pull/44842.

Thanks,

                Ilya


Ilya Dryomov (2):
  libceph: make recv path in secure mode work the same as send path
  libceph: optionally use bounce buffer on recv path in crc mode

 include/linux/ceph/libceph.h   |   1 +
 include/linux/ceph/messenger.h |   5 +
 net/ceph/ceph_common.c         |   7 +
 net/ceph/messenger.c           |   4 +
 net/ceph/messenger_v1.c        |  54 ++++++-
 net/ceph/messenger_v2.c        | 265 +++++++++++++++++++++++----------
 6 files changed, 255 insertions(+), 81 deletions(-)

-- 
2.19.2

