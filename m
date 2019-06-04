Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5430F349A7
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfFDOAp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 10:00:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43403 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfFDOAp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 10:00:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so10413558pgv.10
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 07:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/j0iEirlgVUfVQdfnTTiO0PbSTrbTR+6ViDhQBEOTk=;
        b=WAjClpLiL28cLduOGpIctgPyqRUDTj6qzFVgQRN4MiWHtvhTDN1ywGILarH3gTT79c
         MzzKEY+/EEOL54H94VlU+3AgB7nOvVqcY9eIlLk4bv2cZG7TUSbdleklUsR1WCVyxNk/
         dI9GbLGk97wIjuSxn5YIUoa48REqM94oY1sCUmUN4DoXmdXtY9pgOFEWJ0ULKIPPorOO
         mAljsUI/r1E8PtSkW9hPZv4FxoWMKhitX1sN6CAcKW23g04XTm6FJaQ5vv8l/wnifis5
         8g2emtGakCgntQorx2CJ5uc6zfJGL5jGXaugBSWCTVedC2rcMFWnnm6yfUCvRIOe/Amy
         ljYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/j0iEirlgVUfVQdfnTTiO0PbSTrbTR+6ViDhQBEOTk=;
        b=pu/l7rMVgAzJBIEG1rUT7pfLwvSo/ipPIgyYn0jFc1TkAEXOSRgVfNMx2zcaMtUMXk
         ccBcaS8w7bg4gIAC7E9qKuvuvqFQROTJOEapBI2ORGhogJpUuJaUjFF7/GFyCBjVK9MD
         4asOQTfJn7PkkFxx6amzzTi35JnAzpf6iaaaVGL7VYoZ/348Kx5o0Jh2upvreuZvEfPw
         1I/IsZjGMcajOhdnXexI7DJ+B05cgKcFfA3FU9rHRwfkoslUOcr9O4FTUVQ0rBYHmEND
         5JKaZmzsPGBYdWi4rGaDMa68DC4Tlt5dL1cWUbiu2P28wEmjxKCojIjrt/FTm7CUVWOq
         ZJvw==
X-Gm-Message-State: APjAAAUKestgQ13VMQzff0unfNlkupBOpuc4wW1EV8B/jijdjwSPXZGS
        EGFDiRtVYPsh3L5oV2xGKb0=
X-Google-Smtp-Source: APXvYqzFUl2oqiIw6edW4i78qUltKot5iYeAjKUq2dhejWp9GqWaC/umalTZDd3NNIyZHrjgK5q0IQ==
X-Received: by 2002:a63:1d14:: with SMTP id d20mr35866808pgd.281.1559656844178;
        Tue, 04 Jun 2019 07:00:44 -0700 (PDT)
Received: from localhost.localdomain ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id v23sm19746154pff.185.2019.06.04.07.00.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:00:42 -0700 (PDT)
From:   xxhdx1985126@gmail.com
To:     idryomov@gmail.com, ukernel@gmail.com, ceph-devel@vger.kernel.org
Cc:     Xuehan Xu <xxhdx1985126@163.com>
Subject: [PATCH 0/2] control cephfs generated io with the help of cgroup io controller
Date:   Tue,  4 Jun 2019 21:51:16 +0800
Message-Id: <20190604135119.8109-1-xxhdx1985126@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xuehan Xu <xxhdx1985126@163.com>

Hi, ilya

I've changed the code to add a new io controller policy that provide
the functionality to restrain cephfs generated io in terms of iops and
throughput.

This inflexible appoarch is a little crude indeed, like tejun said.
But we think, this should be able to provide some basic io throttling
for cephfs kernel client, and can protect the cephfs cluster from
being buggy or even client applications be the cephfs cluster has the
ability to do QoS or not. So we are submitting these patches, in case
they can really provide some help:-)

Xuehan Xu (2):
  ceph: add a new blkcg policy for cephfs
  ceph: use the ceph-specific blkcg policy to limit ceph client ops

 fs/ceph/Kconfig                     |   8 +
 fs/ceph/Makefile                    |   1 +
 fs/ceph/addr.c                      | 156 ++++++++++
 fs/ceph/ceph_io_policy.c            | 445 ++++++++++++++++++++++++++++
 fs/ceph/file.c                      | 110 +++++++
 fs/ceph/mds_client.c                |  26 ++
 fs/ceph/mds_client.h                |   7 +
 fs/ceph/super.c                     |  12 +
 include/linux/ceph/ceph_io_policy.h |  74 +++++
 include/linux/ceph/osd_client.h     |   7 +
 10 files changed, 846 insertions(+)
 create mode 100644 fs/ceph/ceph_io_policy.c
 create mode 100644 include/linux/ceph/ceph_io_policy.h

-- 
2.21.0

