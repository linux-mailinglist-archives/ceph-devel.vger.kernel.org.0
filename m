Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D8B2E7BA3
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Dec 2020 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgL3Rj3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Dec 2020 12:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgL3Rj2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Dec 2020 12:39:28 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559E6C061573;
        Wed, 30 Dec 2020 09:38:48 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id cm17so16069641edb.4;
        Wed, 30 Dec 2020 09:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mbKx0VrbcGX06OaD1gA2/3Ij2LLzirD/wkDYpvq9AE0=;
        b=O6JiKAKKBpKsEACJ+nJbzrhpC/wWcEaXgsY2ZqS1Fpw4sVi2okW3pfkTL4yRRdTKgB
         ipFEdnCWfOxt63c1fr9ETg7pjFsHBotYmy8RSOrha4soUwWAa22/kqBPykqjqYscQ1Sl
         vRR3SRewJCj/G5ijicAYloRGn6aKfWer81jklyTiT1dg9KhGDGzPecWCsvVOlrLAy6qA
         Fo828isvddmWxu3xqpD2aIE3MMcWQdUFcfyBQVkSR8jf8VeAtE3YmviEMcaTWj43r0oq
         b0adpisfaRGbRq0P4Uk+19iBqb8SYo1hfR7R3ExswNwVu9x+LQeuL44OB3W5x51g/zq/
         WT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mbKx0VrbcGX06OaD1gA2/3Ij2LLzirD/wkDYpvq9AE0=;
        b=pmqxuvAE84Cs6SWrCH4DNduWFmVYT4g3LW5aW5RZ2aqjQSb7EJht4eVDlI7TA90FlP
         z5KqP5gK5tiYjT3P0YjTpuoXsFfwcPRqNi/APUaQP8cKPmpw5mZVb8yy2Ay++QR0qT9L
         VGIWSDKeBgC2XekQC0yq3astDG19Zd2PE26o0ci0LwkKvUdPKXl2S4dAEqEzw9GMAvp4
         nBl84Dtl5T0qwjC11ilPJ9IiEIDDpa+VhYbpPDnRXoaKUpN/Vrm4UvnjtIm1L9Zsk5Ke
         QjHO7zI1tZX0at2yUGn3VXSmdcvJBjTLJKOm6UINyiOvldv5g5ZVlcjELGYI4b0iq46g
         7GQg==
X-Gm-Message-State: AOAM531+a3d0Lk+PBZL4vXP4CNrNhKGOMY15azFReqU1KvvqFlcaMYS+
        9PJBV8qQkk2TLJta1iN4PvyU/h3YGAk=
X-Google-Smtp-Source: ABdhPJxiytOfWDsB0ffyp6zUyB9WJrtGtCWQ82wMxbLo1LzsD0UuqBUn00+fczFHX+RoXB2zlFB6EQ==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr51220288edk.377.1609349927121;
        Wed, 30 Dec 2020 09:38:47 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id f20sm27361523edx.92.2020.12.30.09.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 09:38:46 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.11-rc2
Date:   Wed, 30 Dec 2020 18:38:46 +0100
Message-Id: <20201230173846.7369-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 5c8fe583cce542aa0b84adc939ce85293de36e5e:

  Linux 5.11-rc1 (2020-12-27 15:30:22 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc2

for you to fetch changes up to 664f1e259a982bf213f0cd8eea7616c89546585c:

  libceph: add __maybe_unused to DEFINE_MSGR2_FEATURE (2020-12-28 20:34:33 +0100)

----------------------------------------------------------------
A fix for an edge case in MClientRequest encoding and a couple of
trivial fixups for the new msgr2 support.

----------------------------------------------------------------
Ilya Dryomov (4):
      ceph: reencode gid_list when reconnecting
      libceph: fix auth_signature buffer allocation in secure mode
      libceph: align session_key and con_secret to 16 bytes
      libceph: add __maybe_unused to DEFINE_MSGR2_FEATURE

 fs/ceph/mds_client.c      | 53 ++++++++++++++++++++---------------------------
 include/linux/ceph/msgr.h |  4 ++--
 net/ceph/messenger_v2.c   | 15 +++++++++++---
 3 files changed, 36 insertions(+), 36 deletions(-)
