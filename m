Return-Path: <ceph-devel+bounces-3355-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44488B1C3C2
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 11:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA6B9189B878
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 09:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EDB25B1F4;
	Wed,  6 Aug 2025 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="EsiiedlG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28515258CC4
	for <ceph-devel@vger.kernel.org>; Wed,  6 Aug 2025 09:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754473744; cv=none; b=pWG9PjFfT//Nd8RNwX7InnE62dUZIlJfiCOQS69slaDIcU808WyVX6LVIlkAqHiM0pV6jHNvhVj5gZ5YIh+5+64P0UrJsPxocy108qtZm33hvIMHS9Mwzpsg+WCyIem6t8z6szT5L0jxCcdLSUgXud+H8bwbVb8FpcoG9gvluVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754473744; c=relaxed/simple;
	bh=5SYIq03Ap7x2Vsl94fmiL13UixJr8VmYZKJRW/hsK6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DhdskHIPEqCz7RcSGeowZ9Hl7sZtFTxQM4yt43QYoA5G30GPwRjvPWkud1ldlcZcVBjEV0dvSDIL/c1o59zo3Oodca8DQfVvOug+36IuBKznsPo73zI8RR9ZDJNmZRtYV21zsZgdXDfE3UI4h1C+f3fiYtfJ94sgjaep/ohco1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=EsiiedlG; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6157c81ff9eso9690025a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 06 Aug 2025 02:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1754473740; x=1755078540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M1Kr1PaQ/sCS57W91WJtkhDKLb3SosYr+Qg8wrL3X54=;
        b=EsiiedlGOxmygdNwU3L33lBU6q/lr+sskRAwdbIFjQIDj/LTMDkQzgVqFpewWfXmAn
         rXLnrfaZHoRXr2Q6ZaWv0kuTGz1H54rsJRzDu/Zlc+5s7G0K3kXPUkQtir/N6QFtcwlh
         zu+3XuctRrNX3qLIs8Qs5+8Mg/AkCCuzfYlNAUJQJub5cKTHCzZp+hx8Fo0Azl8iPDQ3
         bNQ9DlPjijhOeBAAHI0bxXbZ9mEtV0O0UKfQUkHQiCdwxOePX42q7mzPiyAssimmLna2
         VGi3bQSJHzZ2vTRXo0qfnFFQAd7FYlXOwYnQlvXK6KK81SFiyq5PvRaN4lc4LxdkiuA3
         O9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754473740; x=1755078540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1Kr1PaQ/sCS57W91WJtkhDKLb3SosYr+Qg8wrL3X54=;
        b=gYPO4AXiamhXqr24YR3VuG7MPiMqkvb5x3So98DW4OslR9W53j8MEyu4BSp+P6Q/ib
         VXxouFqxzzi6nkbkMC5oUcLW7GSMQ3HBG0j17roql72HDv5DQJdMDGuQFe6V4zoQtOvP
         V1bHQ+v6+bN1Rj6y5lh4DQmWZXdLeHiV6KQX6eDLxZ6OjzjFQ1DOkADDizTU163pOhw9
         7loPn4a8xTdV7gphlFCfhIT/YdTxmg3nBPu28QDC1HigcDmJIqYjE4x6yS464aRHH5Lk
         HTloXHIjlr6NciczT6cPYQgr2jmG7L01DeyeyRaalVTlhrY3PTHn5yE7lTki1jfawzAM
         8IKA==
X-Forwarded-Encrypted: i=1; AJvYcCUjSFcUf1hh0SSm4GjGCbj/B6bGnDE1Fxt1ypO75jUYVItoB0q/agKBEk+bjBKwi3dX0Ltj6qE+2qK0@vger.kernel.org
X-Gm-Message-State: AOJu0YxM6djn/9NdyKPJDVk3KiqnJXxBLeSiwadNt2IWkzbdZ186v31Z
	HRngkVMVa1klZgrGGl8ITkZLuhq1hEw0jVETO/Z+klunM1tpXQdMg5mZzVKfGUpqZsQ=
X-Gm-Gg: ASbGnctZc+Ng6fbaXV3lbqoboC39d3VV7V7VjzbrYJA+1gkfLBFVc+D3q+KYoctsE2e
	0hd7MT9PUU1I6d8zx1NdJHzypaZKhnMzX+SmV3GVwwEIr4rU9upCHlnRlk/QFGh5/H7PcJBh/kH
	gWGhOL+emrjMjqNXN7NV0V8gBJsO5QgaSt4NGm33grOviFydrdmjZWyk9l0NC4eAEuKEvgHqF6/
	9AOlFzMQMJD4XfgkI7g0xDyrkhK4IJdmLE/rDKP/z6k4myGpd0XC/WlPnTqK1/0aCDp/UkAssBv
	sWqP03O4oCBJ1dGf79PZ9LZ7YKVbTTy2OrmfL0Pr2xfZBBWtLxluez145a7u4B0OC5TFtczJHDY
	zgrgVkcxWeQrU178f3HR/uVKz8RlciaBvVB5RWQpDuiQKM7cVZs/pTT9R8Q4nfeAe/XzWFWcRBh
	EFUNb8F8Gh4UjZRrrlz+oWpW8jElZcUUS1
X-Google-Smtp-Source: AGHT+IFd7IMVkyVKga4jKFbVEM74esML9mbnuaKUTJXLq/SVH85ZAtHNie1WOgAgCuoAVfu+725UvQ==
X-Received: by 2002:a05:6402:4401:b0:606:ebd9:c58b with SMTP id 4fb4d7f45d1cf-617960b28b1mr1742918a12.1.1754473740332;
        Wed, 06 Aug 2025 02:49:00 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f12d500023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:d500:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00247sm10139093a12.9.2025.08.06.02.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 02:48:59 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 0/3] net/ceph/messenger: micro-optimizations for out_msg
Date: Wed,  6 Aug 2025 11:48:52 +0200
Message-ID: <20250806094855.268799-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches reduce reloads of con->out_msg by passing pointers that
we already have in local variables (i.e. registers) as parameters.

Access to con->out_queue is now gone completely from v1/v2 and only
few references to con->out_msg remain.  In the long run, I'd like to
get rid of con->out_msg completely and instead send the whole
con->out_queue in one kernel_sendmsg() call.  This patch series helps
with preparing that.

Max Kellermann (3):
  net/ceph/messenger: ceph_con_get_out_msg() returns the message pointer
  net/ceph/messenger_v[12]: pass ceph_msg* instead of loading
    con->out_msg
  net/ceph/messenger: add empty check to ceph_con_get_out_msg()

 include/linux/ceph/messenger.h |   6 +-
 net/ceph/messenger.c           |  12 +--
 net/ceph/messenger_v1.c        |  59 ++++++------
 net/ceph/messenger_v2.c        | 160 ++++++++++++++++-----------------
 4 files changed, 119 insertions(+), 118 deletions(-)

-- 
2.47.2


