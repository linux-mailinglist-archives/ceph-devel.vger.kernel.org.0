Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4B3EAA6D
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Aug 2021 20:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhHLSp2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Aug 2021 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhHLSp1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Aug 2021 14:45:27 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3683FC061756;
        Thu, 12 Aug 2021 11:45:02 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f10so2096674wml.2;
        Thu, 12 Aug 2021 11:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBEXe/K5UkvKT1TccgP9MD9aIiSJbue62tXHdLCwf6E=;
        b=Pi6JW94Wo+EwHZJvNM3ppBAa8EPQCwMtGA6II43jyUc+9dgG7IZ/Xsj4GN6jL5BpqG
         Kdr8po53vNXhOhq5nLzP8X4UDMbzm6WdOl/wot+iDKmy/92dilQewUMaUKf2WoF2dxMM
         6ZHVJWQwGJ460AsGGv0XrJfUXJQs44PSaU2hu3N+0RkMH2egTANKJ4DBajZNW1IYUnnX
         xge9SKWTN+3eYp3/SdkRIpGSiS3ExMTzBBmy8yvUTARy1lwGwbO5UYohjR0s7tlGYpJW
         Gtp6DA80Np4mbBGtU8aZgbACszcLN4Okxk9a7plwGcGoj1Mg//lImZMOeqVSKQhlaNa/
         1Vqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBEXe/K5UkvKT1TccgP9MD9aIiSJbue62tXHdLCwf6E=;
        b=BT4+QL4/hNYX9uqDGxh1bleJkQtg3jYpafOoF8Grrdm4LRIDB9sHkKp0Gg8uJaeHJz
         sGoxITg/WLppDaEIrDcx7gApvBDHGKtIk2kyg1lWOvJRPVXOqTz85wBhwgpfhjW0NJa4
         JT5pcuSCnHgam2bZ7Q6hvE4OyQQ6GMtj7PmYr76Juti0mExDGNx+vXW0VmkDA7AW9ml+
         /uSxzo6a9/YpgKvCcIWqL0hkDZFZGbGZePJcleZmSJDC1b3PnsVYnsZ03FMAmEPSp3w0
         mA+rb3EQ8h/pWvqmT3oJJWwlRgpmB2Jef7TfeMdZEFJ/oknRE2qhfcSrUQZAjIdyChMo
         bIeQ==
X-Gm-Message-State: AOAM533Tp5mNI8Mer8FWVJ3PvokhS6LTG/B1JBgd1kXXXQydt+WjOeDc
        CY/pjyuUuZ+A0jLAnXi1v58=
X-Google-Smtp-Source: ABdhPJw7xVJKUmTOaTrxub33Bv++1Pwvti6IPqc4cFZIVhSzQy6pmB3ziSl/ohdAYM+VtjYm5U8J1Q==
X-Received: by 2002:a1c:141:: with SMTP id 62mr8241wmb.27.1628793900846;
        Thu, 12 Aug 2021 11:45:00 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-171-183.net.upcbroadband.cz. [94.112.171.183])
        by smtp.gmail.com with ESMTPSA id t16sm3912931wmi.13.2021.08.12.11.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 11:45:00 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.14-rc6
Date:   Thu, 12 Aug 2021 20:44:09 +0200
Message-Id: <20210812184409.8832-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit c500bee1c5b2f1d59b1081ac879d73268ab0ff17:

  Linux 5.14-rc4 (2021-08-01 17:04:17 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc6

for you to fetch changes up to 8434ffe71c874b9c4e184b88d25de98c2bf5fe3f:

  ceph: take snap_empty_lock atomically with snaprealm refcount change (2021-08-04 19:20:29 +0200)

----------------------------------------------------------------
A patch to avoid a soft lockup in ceph_check_delayed_caps() from Luis
and a reference handling fix from Jeff that should address some memory
corruption reports in the snaprealm area.  Both marked for stable.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: take snap_empty_lock atomically with snaprealm refcount change

Luis Henriques (1):
      ceph: reduce contention in ceph_check_delayed_caps()

 fs/ceph/caps.c       | 17 ++++++++++++++++-
 fs/ceph/mds_client.c | 25 ++++++++++++++++---------
 fs/ceph/snap.c       | 34 +++++++++++++++++-----------------
 fs/ceph/super.h      |  2 +-
 4 files changed, 50 insertions(+), 28 deletions(-)
