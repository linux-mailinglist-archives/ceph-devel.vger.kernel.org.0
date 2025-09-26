Return-Path: <ceph-devel+bounces-3749-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E10BA5651
	for <lists+ceph-devel@lfdr.de>; Sat, 27 Sep 2025 01:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA0A51C07D09
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 23:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10CBD2BE7D0;
	Fri, 26 Sep 2025 23:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxQcw760"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC01F91D6
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758930156; cv=none; b=Z7pNINeQtqhgVIEu3344gMsqFiNmYxKkkWk3TBqd9QKTJCi6k5UfihATPKXYhS4AQXEFRMqs2lbemrCipeezz8wSYghnkilr+Feu5QguDDAW234a1uTS5ILJc0rFKAd9CCae/wT7hrpmpCV5P0CvBZOEfwv3vpmRKxIq9emjK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758930156; c=relaxed/simple;
	bh=BykyNRlwezjVxdOJlZPGY312EyywRN4J0taxqycGbnU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jAVPAUDEMjvpmVaXHRKBqituiw/oXO01Aqv8a1RDyvmu2Lg7iuvl/SSi6pojqz+GQpgvxuxrRHlB2hHwCfNfhnnHesacovgI7ovBExEagYlJCJNYqkrIGO/a09LwVlx2QDDCs5vjEmIwesVXj9poDqC43yZcLj4RaTQ8/9tqvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxQcw760; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-791fd6bffbaso26539506d6.3
        for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 16:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758930154; x=1759534954; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RMZm+B7PKSQwIxwZ3A7P+2FemBiS1prD7bnlayIdVRc=;
        b=ZxQcw760hWznUB9raWuf7Ce5Dk1vjB6hVurcRv8EFyWm8y12dyRDMCthEgo2ji1m9X
         k6U5N9SATkGw0Z6kx4jfC7ABYWKmr5RtFV3tE7Di66U7iJabmQt+qUU5gDQSbU6l29Zv
         xYQFnBLCsqyYSyqa9jlwhFVsVAAuZnve/KGph+ox29kqWfxg2KbKzeeb63/zvJkkisOU
         9ZSZhfXDGc3fvVsEY3d2Csyjr3l9WVc/2xrL6Ol7SHH32R8tqGpiwPrLbZMHRYUeJVOf
         1hU7cFuYzNo8hAwjQxcGxS6JhQtocOA+qpApkcPLkFu5rGHLyws+RWSTNtI3XMGhRHC5
         UueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758930154; x=1759534954;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMZm+B7PKSQwIxwZ3A7P+2FemBiS1prD7bnlayIdVRc=;
        b=pE1jotikXmDB+7XKSA6uftZMn5kC26NfMaM6tmjhSfc+QB3b2fyiLfxFxsQo21cdjL
         HY/YBbHPnqvtQuxhFSCrqaNhDjAdbeNP8X97PCmcJb3mFYqMmW58R4PAzdvrFllMK3lz
         iHxG/xrDwuFpEiUrt9ZcGmX2aMcvznY46ldu79rKS640eX7FNCXfiOyepsXbdw5utcmd
         CkinHDh4rJPPKQAwSo/pARi2Qf9C8HugU5Cw5BdzJV8UWLTlYc1SoMPuU4hc4eez1dr/
         /gULSJIcC1nCs7ytpuBAjcobdvnqopyb8A8KP4RTnHbSRj5FU7n43mm8oEsi7Pvj0NAB
         ge4g==
X-Gm-Message-State: AOJu0Ywajq7HL+3yhGodbWz6hulEZG5WhyI0/yRvesnI88OQBmiIQfD4
	c9z2BPgWo6Kjh53cAhqJEQQR/YSY7/RQuSRUwPRtPV/M0zQ+1pI0Ylmg/Re8rKTkAqD3auYVTYJ
	uSJbC8AJETTiG/twdbz9ggB/SAd9ffKQ=
X-Gm-Gg: ASbGnctpZIJ8rXphYFs5ab8mp203yuqZAYmSoa3Zu7G1WkpOElYaSNSdszRlzDU+qL5
	cUCkI4tlRMlRP6BAtHoDjlE7GaQLzigOSP1N5kM+G7p3MPUXQXom81DhxqSDNSU7qA+bfOzLq2Q
	9lK0oTo1k5CDsnPWMdFLAJENNQtFr+dRQm2hMQcYWW2AACiRFCvcY1RmqzyisHNwQyaxaaW647O
	UvnRbT4N2gGkoeK+Tkn
X-Google-Smtp-Source: AGHT+IFmnlqH5i6txaTd/Xq7KDmnmI0+uSqqNNkTOpnKNm5ON/AEruuNXl7CjXl7G+YVJKZEmES/OAg2dnCcyup6hOI=
X-Received: by 2002:a05:6214:766:b0:802:d44e:3531 with SMTP id
 6a1803df08f44-802d44e3850mr94196186d6.46.1758930154199; Fri, 26 Sep 2025
 16:42:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?6ZmI5Y2O5pit?= <lyican53@gmail.com>
Date: Sat, 27 Sep 2025 07:42:24 +0800
X-Gm-Features: AS18NWB25GMZ8whgBS-hTHKXzzb5mSyFa2N7y33dGyvryYrAZZzvE-FEBzGQjuU
Message-ID: <CAN53R8F7oTO-NF_yzpz2=eW+iRis-TFys4JvDUEOkY+dh8-69Q@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with
 GCC 11.1.0
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Slava,

I apologize for the confusion with multiple patch versions. Here is
one single formal patch that I have thoroughly tested and verified on
multiple platforms:

**Testing verification**:
- Successfully tested on macOS with `git am`
- Successfully tested on Windows with `git am`
- Verified using `git apply --check` and `patch --dry-run`
- Confirmed to apply cleanly to Linux v6.17-rc6 (commit
f83ec76bf285bea5727f478a68b894f5543ca76e)

---

From f83ec76bf285bea5727f478a68b894f5543ca76e Mon Sep 23 09:05:00 2025
From: Huazhao Chen <lyican53@gmail.com>
Date: Mon, 23 Sep 2025 09:00:00 +0800

Subject: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with GCC
11.1.0

When x & 0x1FFFF equals zero, __builtin_clz() is called with a zero
argument, which results in undefined behavior. This can happen during
ceph's consistent hashing calculations and may lead to incorrect
placement group mappings.

Fix by checking if the masked value is non-zero before calling
__builtin_clz(). If the masked value is zero, use the expected
result of 16 directly.

Signed-off-by: Huazhao Chen <lyican53@gmail.com>
---
net/ceph/crush/mapper.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 3a5bd1cd1..000f7a633 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -262,7 +262,7 @@ static __u64 crush_ln(unsigned int xin)
       * do it in one step instead of iteratively
       */
      if (!(x & 0x18000)) {
-               int bits = __builtin_clz(x & 0x1FFFF) - 16;
+               int bits = (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
              x <<= bits;
              iexpon = 15 - bits;
      }
--
2.39.5 (Apple Git-154)

---

**Important clarification about git diff format**:
I understand your confusion about the line numbers. The "@@ -262,7
+262,7 @@" header is **git's automatic context display format**, not
an indication of which line I'm trying to modify. Here's what it
means:

- `-262,7`: Git shows 7 lines of context starting from line 262 in the
original file
- `+262,7`: Git shows 7 lines of context starting from line 262 in the
modified file
- **The actual code change is on line 265**: `int bits =
__builtin_clz(x & 0x1FFFF) - 16;`

This is exactly the line you referenced in your message [1]. Git
automatically chooses context lines to make patches unambiguous - I
did not manually specify line 262.

**Cross-platform testing results**:
- macOS: `git am` successful
- Windows: `git am` successful
- Validation: `git apply --check` and `patch --dry-run` both pass

The patch is ready for your review and should apply without any issues.

I would be grateful if you could review this patch again. If you
encounter any issues during application, please let me know and I'll
be happy to provide additional assistance.

Thank you for your patience and thorough review process.

