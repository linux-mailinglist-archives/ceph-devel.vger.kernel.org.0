Return-Path: <ceph-devel+bounces-1886-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7E09909F5
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 19:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DA9A1C218E6
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 17:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B631D9A51;
	Fri,  4 Oct 2024 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cn7Va+8O"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26941C831A;
	Fri,  4 Oct 2024 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728061637; cv=none; b=a+ihAGKY9C8f6/CbF+/P0J+xOxXcnPpU46X/1VnL+f2ZlFZ07k7BxOSdj0Cu0Xkf0L4O/ke8I7CukS1gx0uAxGYBnUqOLHOTcM5q7rgBm92OjaKCJHxdyt42cq/QuVZTGxMN+LAyFTBA0jJCfvv96m9lKnnWKbP2jP4HxOxUJvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728061637; c=relaxed/simple;
	bh=mvCeyv4SIVno2bJL5QM2pnGvYiKoJZzwKQIHvndrzck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X+bXEBJv23dDQHE4MPL8+ft60nZlJJuR8xdYeo1ovXm5j+6EhK+/jju+xZHNKyZ9rfVQBdrrcjYkLaPUFTUXze+O7Ijrgck7LuFfn6EqzcICC92wNPSX2aabZLzW2OP9EwnIZhmUgzo9xa8JUqNA1be0ke2WOaMAsHfk/tgo+pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cn7Va+8O; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42cc43454d5so19097935e9.3;
        Fri, 04 Oct 2024 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728061634; x=1728666434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eQKLWF2OQc1DfqF1OXJR9gucTG4tCplF3nwsRq/g2xg=;
        b=Cn7Va+8ONQJAt914vRPO8oWwyzC/Bd74/OTlxs0BJlcEF/CSxNt5R8ex5VW2TxonMq
         YehpGkNdATozuOnB6VBGi5ao7nFQCyyzcKTt6zf3b8z+VrLukN0Orojbx0dPsrfe8xKT
         dc3LORi6PT4075xrgQl5pZ58oaEkg9e6pQmI9sXtrPjN76AcbfbPmJKU+8bB7bJIBE+T
         xFXUHv4zFQKQskepgJya200SjBVNlYPQLoIlFjR3qWEWcziSfheRBQBKeZvV0D+lbUN6
         /Rj2pYIID3Zd6xZw/0T58EQME6MZprvmyryiIA102cQm4TnP7P9T0dcZ02Tjiciquv9U
         Is6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728061634; x=1728666434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQKLWF2OQc1DfqF1OXJR9gucTG4tCplF3nwsRq/g2xg=;
        b=f9CrrjA9/AY+oO5KT3nJRxsjKxWA+XY9wej7KUCZgBcfy+uqLTWSX+f5VK3FTzt4A8
         6Ij+cedQIKCNlnjef16gavN2A2V4YjVvfTBQSrrJc3XGpvoQEC2IGaVdyRjPNcRr3iKZ
         aNUbwfvyk7m6gR73x1HfxnwL0UZCCD3AqL5ZQ/tp4Gy5BRQ3PJAFW+hLGvwnG0t7Zuye
         v2W0HiN4twP6bq/CUJBZxFqPGE+MJR/DrAS00kZtofvyIfSWbrCLUQZ3yF/fCL6ZsJu5
         l+AkkrOyPqZI9tHk1jm6Cj1Tse6+qXcSJsijkroj4PJ6ktAUeTnWjUBVGuXROVmXrCTL
         4QXw==
X-Forwarded-Encrypted: i=1; AJvYcCU8MQHRuLf3PLCDs17Mc9dymu0jSSNh8CS1TNdazF8yk3f4ZU8M/2854P4gvH/MGeEWgJTaQU+zMHotE7o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjQvQBuCWu+VhtjJZ45/VR0GnxVtbhu6OOYiJEcb5M+ai5E7eB
	CMC+WgZze1QRXkW8ufKax8F8lenNRDD/TEnpS1oobRvLv1ZJnRjH
X-Google-Smtp-Source: AGHT+IFN0exRHlRhDFXYHgNW6XBMNFygMdRC4PJfPnlT/uhitIrGeceQhqjTGx5NxCsVxvX80A4rhQ==
X-Received: by 2002:a5d:4535:0:b0:37c:cfbb:d356 with SMTP id ffacd0b85a97d-37d0e760978mr2022683f8f.28.1728061633775;
        Fri, 04 Oct 2024 10:07:13 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1695ec1esm75385f8f.74.2024.10.04.10.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 10:07:13 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.12-rc2
Date: Fri,  4 Oct 2024 19:06:56 +0200
Message-ID: <20241004170658.479285-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc2

for you to fetch changes up to ccda9910d8490f4fb067131598e4b2e986faa5a0:

  ceph: fix cap ref leak via netfs init_request (2024-10-03 09:31:08 +0200)

----------------------------------------------------------------
A fix from Patrick for a variety of CephFS lockup scenarios caused by
a regression in cap handling which sneaked in through the netfs helper
library in 5.18 (marked for stable) and an unrelated one-line cleanup.

----------------------------------------------------------------
Patrick Donnelly (1):
      ceph: fix cap ref leak via netfs init_request

Thorsten Blum (1):
      ceph: use struct_size() helper in __ceph_pool_perm_get()

 fs/ceph/addr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

