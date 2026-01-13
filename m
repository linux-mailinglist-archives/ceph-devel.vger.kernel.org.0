Return-Path: <ceph-devel+bounces-4367-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AC4D16863
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 04:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBF4B304DB5C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 03:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EF234BA46;
	Tue, 13 Jan 2026 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hABf+fbg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A2925EF87
	for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768275088; cv=none; b=SbWBh3L3ZIYdsI87xqSkjZm7SxcexlAOUAu+9JvNgrqAYP/LPkwEFVq3JOcJ/EZvY30omUNt7BLPedywPM1i/8uLwSk/+HYjsh2bdAHg/7rEyrLawppi5RHoeRY0pGXdLzODpy78ukCxlLWSOBI7YhDqJEwkA+ABRHW0x3Tx+G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768275088; c=relaxed/simple;
	bh=2jZQrijQ+tMvDjnXgemv2Abg5KZ8Ot6NpxIAyBCzVqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yr05k7TCN+7w5R/0nO69Q4O4jYCW/FM35SiWll63vMXviac3pGQiEAWnNJlOjUxm3QDOPFKj47V2Cfjcwm4MmYURoiDe4uCMTnF36tAYbCxUBDrwnmBQuAZx3CFzYHa+zonG4HAA6haOv5syDg6N0MCkEhMycl9ybwfYH+YIXWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hABf+fbg; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ae255ac8bdso1693558eec.0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jan 2026 19:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768275084; x=1768879884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XpToMtc+0/+Om5Rk3nVKl+sextCHgEo4MIq9cpMuk1U=;
        b=hABf+fbgQRVXra/yyZDwI1+Mhu61/7cuIYmmQBdnt0JnaSiAWzrXZ9EAS8qdWa+6qI
         A4KQ1I2F5lImAizg8r7HT5TV2OGcM9KhIBCl9jvoLliap1aFDGTGAavXrTZSGREtMVfU
         f02RyfiG7kcnb4BD+2qkTjsxBwoDiouZ5aCEvbtwillMR5Yb4mgLZDBaEcy5/GVhHfvg
         O3iylV/mKzFF+i3ZRZgWYQy7WI7L+5+QtC6zNJemaYAIv2T0zwty2NmDfTZYs/jh1Fp+
         krxxDAWYo33Iac+TJ37E5mLevJB626UB9bLW8tnw32xVI8RY6bCLSzMlMXhJ4LDAUOqs
         5Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768275084; x=1768879884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XpToMtc+0/+Om5Rk3nVKl+sextCHgEo4MIq9cpMuk1U=;
        b=exvBMrxyafmG+SCcen+QKfBaNpCuE0cUpxmi83uQFWPZ76T7SVEbrPJbU/BqMt5xIn
         1EPKdw9NR8bM5v8AqiVZA9hWdhnUr3IIU2UX1eWqUr+XSbm6dVK7NzidGIKWIlUbjbiP
         AL4McoNl3E7LvV3vexZVZac8wqfrbqr5ZmIXoPml19+nBZ7mILenYF8Zj/b4YnsCYdyK
         13EKquJd3AbVqYJ7QOWJMzoLZGsnIgdHH+OFEz2tYqIepVPU8Zkd050Gp46mkje1yPJk
         C9qUD7pNYBR1ywh5A3QEXnZdKePJR7faUuw98Soaqgh7aK6/C3pp6QkYNeOJiFrWdUeu
         Ikyg==
X-Gm-Message-State: AOJu0Yye+i0TJEC3k6rowhLgsZfmNxpb+3TY5eBxfd7aR5L/rObdA2ND
	rjPFm8+Z9uwq62YmmfU8ak/hVPAc9PFSKXdG+7viJhZeCMWqsc6A/dkO
X-Gm-Gg: AY/fxX4b3NoHCCjMvMoOgM8K58ayaB6ryCdZLXFFeJNKfVS4slzkcibw5FDj/5lsqfq
	UsxWfAurSf/ry/qyaGLxS81XbKfp+oPqj4ANCpUJRecsT16GxBwq4rYUVNMf4ZlpyeSkEZvqcTX
	sjzZymCxLtv3TlLJvxUjk7UfIOIXZySXmS0XD7zIa8AQY1JBhHiiOQ6Gruo1D1e0NRxaitRo62K
	qTD+8FKKF6fmhKjfoIcIuCxzuAH4oXUezzK0rFSJqE9dnkHsxfE5wOfbxkAfYFE3EFT3xEu1B1a
	rbv9Q+YJV59SzpsDE0aKof1Sm96Vxsk/zGN2J+B1jNNdI3MOkGJtS+R6LbHdRVyl8OyPYQkL4NJ
	/6zkNPW+HqODXYLVz1rCFc2+YCkIFtpzxNxp0EZKseA+UTg1rpwoIT3jpqt/22Q5kmzCE7ZAhVv
	skXjRVBQlO1uXmcP9ExquVQ+xiDwNUw7GPbHizC7CXJ9qwx2RixkueqLFUbPUg
X-Google-Smtp-Source: AGHT+IFfCldV0MFiU8jNbe5w+1ZPbHGM0SmsKjJJIfKvdjWI82rZrG74O32rfwskmaigz78HOgBTPg==
X-Received: by 2002:a05:7300:b094:b0:2ae:6146:37ab with SMTP id 5a478bee46e88-2b17d22955dmr13394320eec.1.1768275084279;
        Mon, 12 Jan 2026 19:31:24 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1706a53cdsm16930800eec.11.2026.01.12.19.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:31:23 -0800 (PST)
From: Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>
Subject: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
Date: Mon, 12 Jan 2026 19:31:13 -0800
Message-ID: <20260113033113.149842-1-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the OSD replies to a sparse-read request, but no extents matched
the read (because the object is empty, the read requested a region
backed by no extents, ...) it is expected to reply with two 32-bit
zeroes: one indicating that there are no extents, the other that the
total bytes read is zero.

In certain circumstances (e.g. on Ceph 19.2.3, when the requested object
is in an EC pool), the OSD sends back only one 32-bit zero. The
sparse-read state machine will end up reading something else (such as
the data CRC in the footer) and get stuck in a retry loop like:

  libceph:  [0] got 0 extents
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read

This is probably a bug in the OSD, but even so, the kernel must handle
it to avoid misinterpreting replies and entering a retry loop.

Detect this condition when the extent count is zero by checking the
`payload_len` field of the op reply. If it is only big enough for the
extent count, conclude that the data length is omitted and skip to the
next op (which is what the state machine would have done immediately
upon reading and validating the data length, if it were present).

---

Hi list,

RFC: This patch is submitted for comment only. I've tested it for about
2 weeks now and am satisfied that it prevents the hang, but the current
approach decodes the entire op reply body while still in the
data-gathering step, which is suboptimal; feedback on cleaner
alternatives is welcome!

I have not searched for nor opened a report with Ceph proper; I'd like a
second pair of eyes to confirm that this is indeed an OSD bug before I
proceed with that.

Reproducer (Ceph 19.2.3, CephFS with an EC pool already created):
  mount -o sparseread ... /mnt/cephfs
  cd /mnt/cephfs
  mkdir ec/
  setfattr -n ceph.dir.layout.pool -v 'cephfs-data-ecpool' ec/
  echo 'Hello world' > ec/sparsely-packed
  truncate -s 1048576 ec/sparsely-packed
  # Read from a hole-backed region via sparse read
  dd if=ec/sparsely-packed bs=16 skip=10000 count=1 iflag=direct | xxd
  # The read hangs and triggers the retry loop described in the patch

Hope this works,
Sam

PS: I would also like to write a pair of patches to our messenger v1/v2
clients to check explicitly that sparse reads consume exactly the number
of bytes in the data section, as I see there have already been previous
bugs (including CVE-2023-52636) where the sparse-read machinery gets out
of sync with the incoming TCP stream. Has this already been proposed?
---
 net/ceph/osd_client.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1a7be2f615dc..e9e898a2415f 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5840,7 +5840,25 @@ static int osd_sparse_read(struct ceph_connection *con,
 			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
 			break;
 		}
-		/* No extents? Read data len */
+
+		/*
+		 * No extents? Read data len (which we expect is 0) if present.
+		 *
+		 * Sometimes the OSD will omit this for zero-extent replies
+		 * (e.g. in Ceph 19.2.3 when the object is in an EC pool) which
+		 * is likely a bug in the OSD, but nonetheless we must handle
+		 * it to avoid misinterpreting the reply.
+		 */
+		struct MOSDOpReply m;
+		ret = decode_MOSDOpReply(con->in_msg, &m);
+		if (ret)
+			return ret;
+		if (m.outdata_len[o->o_sparse_op_idx] == sizeof(sr->sr_count)) {
+			dout("[%d] missing data length\n", o->o_osd);
+			sr->sr_state = CEPH_SPARSE_READ_HDR;
+			goto next_op;
+		}
+
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA_LEN:
 		convert_extent_map(sr);
-- 
2.51.2


