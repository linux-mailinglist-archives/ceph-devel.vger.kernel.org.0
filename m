Return-Path: <ceph-devel+bounces-4213-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D9507CD34DF
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 19:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BF14300B997
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 18:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83EE2F2905;
	Sat, 20 Dec 2025 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QC6VONCK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725E296BB5
	for <ceph-devel@vger.kernel.org>; Sat, 20 Dec 2025 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766254321; cv=none; b=du8CtJgi008i4eBvZLDgHch+vTWyYIZ1OBXzjwGQjTDIpNAzQvEHhSxWvQWcM6smYQJowf+M2/FQhuJmQpHIQMQ8EDIBrJ7GR/u/1W0n4O1gi4VOZgLJ/3dQWFjcfHQ12NkEKoEC+Qjh5aBHpGNC0jWeNgfR+Q88d+My0LfSWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766254321; c=relaxed/simple;
	bh=Ay3KGStVgzqEmjhLIfYGf6oieNagHUwSAZbApxiWH74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nFABMNbEz+sqF8wgZq6K74s4X+AU8TGyciLzopK77Ia2LrZqGtHxpCBlml416+7iidCZqwb6MuNfUXABUg5UbO2SZ5DIsZsSJ9vMaws13xHU1o9gA+nZVMXf3f5Z4++2aWBqF3hGaIatot6InfazBoqMMRSqS5Z5AVZ1b563xn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QC6VONCK; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a110548cdeso38872775ad.0
        for <ceph-devel@vger.kernel.org>; Sat, 20 Dec 2025 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766254319; x=1766859119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OCPrsavXRrgCkioku0preGR8OkAAFMEdGgsNu7tZv/0=;
        b=QC6VONCK00zk1WMSHcZaTG0t3ysPJac27Jv8MtAorrTe3ETdkH58Bx+rXtSWeKZkiA
         25/VmCnlWjfOTea2HP5lvaMMmYzmCUnxPn2ud2fDVaOctyipJYnQ18gefCmMVc+Ol+5G
         K8DOGdtdbHLbpSHdrpDt5U5H4FsskJg3FP5gnn56TkM0A3vllNG5b+/iHYIo7wOB42u+
         vmi1r+ePauG6iHX7Ng5YtkE2RGVLX/aYw7iRMi82g1vqsGccr881fV4Aen2i/2F/5hNR
         EsSYMQmuwapjrRYtK85amJZQJAgu3LhEKYHq0NcmKc7AZOuZL3yGL2xV0ht+hoerNXB0
         FCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766254319; x=1766859119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCPrsavXRrgCkioku0preGR8OkAAFMEdGgsNu7tZv/0=;
        b=Jwf9e2HL+3QdLFIcV2ndk9I4DtDghDxApfPhqiI80gMQRDWkE2RZdH/GQgCIVxVA9y
         Jg3W6D6NEP1OGKZK4ne6qivs7SCLYSy9CWSHD6VXKTMu/r+yf3QXVmh8wPDRrPt3w4Mu
         JtP/cglxCUePENtCyjj0zD7rMYEDUaPYqWwRV2YdcK2IrzMHHQlXgvciJjXM78HaV+eT
         GWoK3aa0piItF1N9Zww0gmPIFrAhoFV+bn8uuuJOJziCyfjfODN2ZDzdV9X6JJjNg/b1
         PDbtjd8X/NpaCXUvPJQT85xiIjMswnDVZ4pnfcym7f0LwNN9+KMAzGYavRMS8d4W/B/m
         +J4Q==
X-Gm-Message-State: AOJu0YwFR2XIRTERPqT4aITv3pfCfk4lcVEoQH6A6HBjwKqsRzkXXX2g
	fU6MQwjpdQkSNeOz087y65caQfW/lao6DYVgDEnJWNK0jMHxIjEDOG4P
X-Gm-Gg: AY/fxX6QRJHNNP1Z8xX/FewY4TZ1zn1mf8QW2wg/+fs0Jy543i5ndWso4PtSZD3oJHJ
	fpZSIyCZWfXGx6+ABZIiSDFFpByjqd2OEDkKWb3DLJUV5j1I+LhfC4siUGhN8SyZJSmOQjRf7JP
	jkVFYLKpYZbbbUOOHYsY6d4sZu9T9MFNpzNktahYWJy04kEaMcGcq1pZNt6K/sNavwIkR3slqT7
	B5zWlo5Do1Q7VY2rW2pFfjrvYxkXB6zvWvL3ew0DC1PIr41SQu+xzuCn/cQ/G6FAqcHg4XOsxmM
	GtN77dw3r5OldTqAsi0GshCSbFOC6IaSgpfVrMBTqhS76aN/MrD2QGBphH/bmWuI+2QtV4p8k3l
	mcNQMMOuRNXlkji/sd+qoOXQOCJjxoU4bdjQmE9ascXMF1zxARs6zW/CxDCl+7cZdooi8ggYzq+
	rH8KdineDvF3fX6Ry2sbFb1beElN4xTCimFYse/mcyHj0=
X-Google-Smtp-Source: AGHT+IEuKZUO1bxNs2FSDcuN04H0zaA+q7W8IXJpJUS/kqD3kBRFMFi/lh36QgFBP4ZWFQbTKjulkw==
X-Received: by 2002:a17:902:c403:b0:2a1:35df:2513 with SMTP id d9443c01a7336-2a2f22317b1mr64715615ad.17.1766254319364;
        Sat, 20 Dec 2025 10:11:59 -0800 (PST)
Received: from localhost.localdomain ([223.72.88.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d3e1sm54325085ad.76.2025.12.20.10.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 10:11:59 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: idryomov@gmail.com,
	xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH v2] net: ceph: make free_choose_arg_map() resilient to partial allocation
Date: Sun, 21 Dec 2025 02:11:49 +0800
Message-ID: <20251220181149.46699-1-islituo@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_choose_arg_map() may dereference a NULL pointer if its caller fails
after a partial allocation.

For example, in decode_choose_args(), if allocation of arg_map->args
fails, execution jumps to the fail label and free_choose_arg_map() is
called. Since arg_map->size is updated to a non-zero value before memory
allocation, free_choose_arg_map() will iterate over arg_map->args and
dereference a NULL pointer.

To prevent this potential NULL pointer dereference and make
free_choose_arg_map() more resilient, add checks for pointers before
iterating.

Signed-off-by: Tuo Li <islituo@gmail.com>
---
v2:
* Add pointer checks before iterating in free_choose_arg_map(), instead of
  moving the arg_map->size assignment in decode_choose_args().
  Thanks to Viacheslav Dubeyko for pointing out the issue with the previous
  patch, and to Ilya Dryomov for the helpful advice.
---
 net/ceph/osdmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 34b3ab59602f..08157945af43 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -241,22 +241,26 @@ static struct crush_choose_arg_map *alloc_choose_arg_map(void)
 
 static void free_choose_arg_map(struct crush_choose_arg_map *arg_map)
 {
-	if (arg_map) {
-		int i, j;
+	int i, j;
+
+	if (!arg_map)
+		return;
 
-		WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
+	WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
 
+	if (arg_map->args) {
 		for (i = 0; i < arg_map->size; i++) {
 			struct crush_choose_arg *arg = &arg_map->args[i];
-
-			for (j = 0; j < arg->weight_set_size; j++)
-				kfree(arg->weight_set[j].weights);
-			kfree(arg->weight_set);
+			if (arg->weight_set) {
+				for (j = 0; j < arg->weight_set_size; j++)
+					kfree(arg->weight_set[j].weights);
+				kfree(arg->weight_set);
+			}
 			kfree(arg->ids);
 		}
 		kfree(arg_map->args);
-		kfree(arg_map);
 	}
+	kfree(arg_map);
 }
 
 DEFINE_RB_FUNCS(choose_arg_map, struct crush_choose_arg_map, choose_args_index,
-- 
2.48.1


