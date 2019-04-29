Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D427EB7F
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfD2UQG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 16:16:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45188 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729358AbfD2UQF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Apr 2019 16:16:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id s15so17844043wra.12
        for <ceph-devel@vger.kernel.org>; Mon, 29 Apr 2019 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L14+mVgpFPqR6PXB76MX2XZrP0FVM4lLU8EXKkexDzc=;
        b=p1MVMVkZfXD7VH7VAdpMlfn+K25MvJCB8GjUIb8s4KL5vdJXzEIjKrNVO0tWrsp4EY
         rZuXgmobi2BwqIh/efoKP08s8Fj8rjY+cmDs5U30A5ldRLuBCEpDKBlcyLDYNDvdbidK
         kGku/H1isgEG9s7kUlB0YeG0/RT3cCVNqKnS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L14+mVgpFPqR6PXB76MX2XZrP0FVM4lLU8EXKkexDzc=;
        b=sdSTKr8Z/C+9umYXd0UPYc8g0x1m7VxocjzZO8sQ5Mct53sxxcrpN9UFmbNATRzqBV
         ovh8c3uVzP9UqYTsKe9iCcBkiazlvd9gqGWofx0w8rYoD8vX57cbeddzPeS2bmaErkMF
         m3xWeP1egUVuR/sEL6bBLN9SE80d+WWq0F17g2Wuj7MAt/E5adEeRo/K5rOob/NO/0TI
         bQnCWlIlVB9DEpIB+9R7lxDioc/qXN/GqO4BhyFuHmOpzbIHYu1r1j8jNG5GasIzarIM
         uOuyMjc13pb9BPbkDNjgC80AP+Vz4emk1+ADbtTlLI9dllARG6bWpgpnaX5bfi4yl7KP
         ABRA==
X-Gm-Message-State: APjAAAVGsbImvf2OBzbk5G0ljSZmQ1VrKhn8jUbq/QZDG/UJnfujVuZU
        gjtWSkRf0LHaN5PROSZpWNzspA==
X-Google-Smtp-Source: APXvYqy9oJ9vdfCQf7W9AoeXXL5QufvPVwHHMvpf9iVkhWgl6YC0+AZuMexBTegFf+EwHB9f8B8yEw==
X-Received: by 2002:adf:f84e:: with SMTP id d14mr3684795wrq.21.1556568963757;
        Mon, 29 Apr 2019 13:16:03 -0700 (PDT)
Received: from localhost.localdomain (ip-93-97.sn2.clouditalia.com. [83.211.93.97])
        by smtp.gmail.com with ESMTPSA id k6sm22864019wrd.20.2019.04.29.13.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 13:16:03 -0700 (PDT)
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 4/5] ceph: fix improper use of smp_mb__before_atomic()
Date:   Mon, 29 Apr 2019 22:15:00 +0200
Message-Id: <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This barrier only applies to the read-modify-write operations; in
particular, it does not apply to the atomic64_set() primitive.

Replace the barrier with an smp_mb().

Fixes: fdd4e15838e59 ("ceph: rework dcache readdir")
Cc: stable@vger.kernel.org
Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Sage Weil <sage@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
---
 fs/ceph/super.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 16c03188578ea..b5c782e6d62f1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -541,7 +541,7 @@ static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
 					   long long release_count,
 					   long long ordered_count)
 {
-	smp_mb__before_atomic();
+	smp_mb();
 	atomic64_set(&ci->i_complete_seq[0], release_count);
 	atomic64_set(&ci->i_complete_seq[1], ordered_count);
 }
-- 
2.7.4

