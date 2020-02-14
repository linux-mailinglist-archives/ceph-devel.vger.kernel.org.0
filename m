Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2815E6B6
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 17:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgBNQtl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 11:49:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43112 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbgBNQte (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 11:49:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id r11so11619500wrq.10;
        Fri, 14 Feb 2020 08:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPIxBcWGN8qvI0FZX+szZRmMvh0tAzoO6Zgc4GjqA8Y=;
        b=p74thIN9AMW7PkIxOxQwb7BJoWY4i+0US7GZ29w+1JxqJf6SUPlZGUYhJo5iANvdPU
         mqYdNx14sNyhSIlvxOZJY0Xs7WH7+aW4222JXhKcWqKuzd1mOzuLjVWllgtO+dbxqij5
         +VLavUpjBIl79UXSY4+fMIbE1lOqEYnec9C5gOjPXHzc3XjSUcgzoJiTSiV2wOd75fUv
         iCatxvIS1tRKmMYM5p5IG0isXX2YGO6QT4Fh2lgbfCOhuAFQI2SiRtKzTv428dMisoRO
         kkuUK5Z7M7Lu3JSkUNi0FERorj6iOTE/0dmd5Ake+eu8S5XkFn/FLVhpU0kCXANQ23PD
         phSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPIxBcWGN8qvI0FZX+szZRmMvh0tAzoO6Zgc4GjqA8Y=;
        b=cKu6Th3ZZuXuCS/A1nwe7cVHm1at2GqlIg80Z2lIt4YD4s3ZjniXILTpgGW7vPftEa
         5h+nVGt6Af1LhgJr+rTEWhGS8nlPnNsPoC8vpch2mnwpTKrJ1KV5MmAZRxZ6NkQyIPgF
         PFkL6UTsNqMlekL34b4KPMLFRIKQPX1dEQWrtzbVcqoPeIlHtYKUwaRvx1kGfX2watNm
         0dY9/GGIJr9cZL2Uk0UgsSuZuL1kK+8CpNaowN0RZ3dvvt4jbbNIM3IiF4auq77b6+Sh
         3zZmORoZj2M20VHTLNHpv+6hO/p/8bDUYNKf4O2kUl2S0ml7YBRcWI+fO3A8VT792b2Z
         eESg==
X-Gm-Message-State: APjAAAXhrUxYImzXs/JsVue6HYN2qK6DqV7DEl1az9woGF+QJz5sQdpR
        etm+ZCCdxY3EWhR5P2oBsNCWa4rYYTY=
X-Google-Smtp-Source: APXvYqzOOar2uuq59Crmvf5/mtFOp1naDnTTJMfC1uVazTi98BMDyC5aLvLpSDy7BKveSnawuakKbg==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr4851285wrs.420.1581698972039;
        Fri, 14 Feb 2020 08:49:32 -0800 (PST)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id o9sm4860233wrw.20.2020.02.14.08.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 08:49:31 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.6-rc2
Date:   Fri, 14 Feb 2020 17:49:44 +0100
Message-Id: <20200214164944.6044-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc2

for you to fetch changes up to 3b20bc2fe4c0cfd82d35838965dc7ff0b93415c6:

  ceph: noacl mount option is effectively ignored (2020-02-11 17:04:40 +0100)

----------------------------------------------------------------
A patch to make O_DIRECT | O_APPEND combination work better, a redo
of server path canonicalization patch that went into -rc1 and a fixup
for noacl mount option that got broken by the conversion to the new
mount API in 5.5.

----------------------------------------------------------------
Ilya Dryomov (1):
      ceph: canonicalize server path in place

Xiubo Li (2):
      ceph: do not execute direct write in parallel if O_APPEND is specified
      ceph: noacl mount option is effectively ignored

 fs/ceph/file.c  |  17 +++++---
 fs/ceph/super.c | 129 ++++++++++++++------------------------------------------
 fs/ceph/super.h |   2 +-
 3 files changed, 44 insertions(+), 104 deletions(-)
