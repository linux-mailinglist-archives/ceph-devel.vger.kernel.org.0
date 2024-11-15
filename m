Return-Path: <ceph-devel+bounces-2081-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D7E9CDD66
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2024 12:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 576A8B22308
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2024 11:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9AF1B2195;
	Fri, 15 Nov 2024 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=myyahoo.com header.i=@myyahoo.com header.b="UBzKEsqC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from sonic310-19.consmr.mail.sg3.yahoo.com (sonic310-19.consmr.mail.sg3.yahoo.com [106.10.244.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380A7D3F4
	for <ceph-devel@vger.kernel.org>; Fri, 15 Nov 2024 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.244.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731669885; cv=none; b=ImgDw6TvNePTeBMYNvjDuAhfxfHZzD/vuL2pJ3TZT8sQxl1WHSnKiSOgB9GqE/6ZvJaBkKwqtQl1cw3ZTWHhttz4q8YFNelBrr4JhCdns7ie4a8C8m+VTb3b5aLuGS2OIpQZL3PR5CaJmToVHNwh8/eFFIcNe8eo1S6qB01AKh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731669885; c=relaxed/simple;
	bh=t0Fl5hfSyZNiuPBvDejZLRu40BusxN7bDAG45nb+WZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=L4PgYlosbs2k3VpebWEzMF/HJGDN+jzZj26z04ehV529ZB432BQjvy9Sm9xs0FIBLh8bYrEtKU42sAzFME/QkyZiunb+8Rhdhz4NUKKKFWqXEOaD7C/0QEQQqHQBWT+r7Qjh8kG19S+k8KvfaotquPVhfz9prGyt5awFED01DbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=myyahoo.com; spf=pass smtp.mailfrom=myyahoo.com; dkim=pass (2048-bit key) header.d=myyahoo.com header.i=@myyahoo.com header.b=UBzKEsqC; arc=none smtp.client-ip=106.10.244.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=myyahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=myyahoo.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=myyahoo.com; s=s2048; t=1731669875; bh=slYMq2Zmby0491A1PE7H8ao60Az9AMutaRCL53H62hw=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=UBzKEsqC6jRZgIPLCoQVeFPWXtHsgRSieURYcZ5Ap8oWLFpHXoiiFg1k+ufRAVqTVIRaz49LRLRLiXPqahoLgpo9PqYl1eJVRkVBS2rcTuvlXIOFR7jhX6y7Jk9VggnW8K2x6wHDVCvNQYDMNqBi4gseCBIOQ1uLG/5IdYS98ODQbshproUyxq7yM0mR5XVIkj9wPc+WzP7T6qKIH7W0YKz+Wtgjho8WL2ElE+SRjmE4NTa7pzcp6h5f/Dyx7SKBl+Y/HF7xuKJ99EWhZr2n90PvSWYpgvwcFKZOBRvmTsqNu5luKUEoZMhDY6mTJDYvKSoxenfUsJxn7OOX47Widw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1731669875; bh=zNitpFp8uUxC1vF8jUB/vl1kv8bRHd2Yq1qQ3KoSzwO=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=nh03Wytec4Rp9xXsV5r0Alh40FTZhZp0/YBxUYFvVktvXC8DaURlwd3DGTj79o06fIRz7U4XM0nRaunxLfariFar+60nVBI5Tr+YaxTaYnaUJWx4YgUENeYbFkeaMGph/aFl2M8VVqzmSmXeeipVnNXRtv8N9QJYDq4XXYHffx6ubCjWghOC+ia9tZoU/IhSt8s54YMpuJO9iuzt2+o+VTp9stOLf+JRcidULG6BTukH7qUtpYtjug+WcBaPqug51OUlJbhVwbTPWfMQj5T7tJ7CAne0A+QqEtR8A+mNYD7gL2eBs6OxxnwOoVDei68pUuNne1uLyxruCxqNDm9hcg==
X-YMail-OSG: hejv99EVM1lSPqrykHDhFKDGiuwUHabCln9Os.wApfMRQv8U93ubwdvVb23Bhig
 uskkdF6Ojqrt3SLrYydimWZJSN0QttvFqc_UQIgCvpRCW4wi3wgtbPDyZDpk5.oYlU2YzRlnTsMn
 oh3xX_h8QbNgO5qOQxHsP3CHFJZmWnW0pnOQAMWeHjkUuGiwYlDJGm_.1yagr4eLDNrUuMHrRpLE
 PXqnrnfjtZvC0IZYMjlNWp82qedU.8frG0QDM.1LVzx8QxWrCHFl8BuMrMm8Td5JXp8X8QxRrBIj
 zLnlvLw.tAhI65gu8Qp5i1bjh8M2uckecZOPYIc3ikyJ7yWSOg6kPIAVgST5aJ9uQI1YtlbIWO5t
 Rwkbs07JML6WYT1N3ilZ6edEXwY.c7TKjZpKAscYgdm4HDXygEZC2BFXG2F9QFljE2iVY1MLfNyZ
 Mmryk2d9jH5bHEJkMc62ITEm9BxTL7bcQlRtJzviaKLoUGlEFhAF3l2PHGS78yolQkc5M8zGELzD
 G46gDdh9hCzAXYnzkErpTd4zNhnaOsFQk6vQpbF_KCUh2AWtUqCV9CySmwDjiVAeKWTy08Lk_1lU
 SGX_rt67jHk2M2AaGzUNAKq3G8dZyiBc.YkoaC82JBySy0UcsNpVpafQ4lEyIvA7yRzwoBYgucLA
 9aaCeyZYla4JqKdtuQovcEZSwDTDt0hJEVnk7s7UdI.y_JLlyGzUtTvLPTgPazfm.i3LcuFAEj9V
 IV6HvSXoiBTkjOtxLNlBBsSYZth4zpi5siwcdvIrCXH.fht1XRWY.WsNlTLYEH16_dsvVW6ctIM4
 w4B1vAmPR0o9PN.ZV2FZrJ.DPwgfJC1dGIb0q8Q2W0zZbA1yoCujO194x9SLIK0i_L7MicdYhd8h
 UMYni2vsbjzfKKhTL_4xoqGuM_G3un8JmUqmTbL0YmCbyn6lkISLfgrtLhJnB2W0Oq2Rj2NRp4bA
 aw1a4AczTnm8hjxe26FcS0..bCN0hPliAw9Py6a5fThyy_mQXnbTaJQThsf6fe2nHpHlcPIMFeet
 O.9DquiupoOs7h0AX142kIZE6FGAesocLp3f4uYbRbh6V1akxb1tCz5FMwSbsjYhxO3g_rRwVVnF
 dGUiVnYWvmnkpN_OwKKyf_dWtcsXBbBdgeN6QilVGSjS1YFytV2Zv1rM190HeQUlu1L.VFLGewlI
 PRXqUiud5hwGQvAlmeRoVXNqkwVcUYd2y8OWfriwGOgtM3GImWgGTJHUJY4KXYnWC8zSdHQqMhX6
 akCEX_lB0nEeXhpv3uvN.D7iz9fWjlmiFh8V44ju_WD.FHiwhT3_3McjT8VATMvo5DW26nrqVjM_
 .mtSzPcaBAmN0b3qqwSf2lY4jDIXDAkM_MMmXxHIRfnDS..9FjLPbf1UEiuK3hmyxPHnuy3RRaTm
 kNq5nX4vMD1nUKNLD4B3QZuHjVX5Hnt97HJf3F9s0dB9fr4NB5TfRDRGL.3XERxkv6moDEyyuEil
 Ui5FIIX8GsD_MGXZm2vgifB7MpHu0F2f2KwMI8vOw0vAvtzdr.FYDrHdswa4TB25wpDZRGI5Id0g
 DFKrCW1e4g11IUXtgZJ8LLwMVqHukhT9gSl8r7OE6IH5gqEF94tzU3SuBJMQXvQCPXOjFGqDR4vC
 _7FC7M1OsLB_rPS2kYTgWomqYACb5aCCgMrUYxN1Gn7Xkg9PUSukehce9NpcdbW7Z42MhplKrVA3
 gHl34AaatAv24DhID.k3Ue0WplXtr7tXTgoqwPdtfl4O.tDNpUpGV14C234zAwCUZos2WaQAtkuo
 M5feo8gA71yLLovXvFoMC4zaJPN7Bbz3op8E7gHkMpeyVlLnVdVLw1NIiNW9uMVE_eCxDWTf1IID
 ZxqjV.mX9pq.UN7E7c3e5e11lbiiffmYQcNt_R4k8An1UBAbzjbYKzIWPk68gHOdj9O8I5vWdMdf
 ytk12atGm8Jq1qUrOETt.yhgLauvCpcGqCg6UYTqDVqPywyXeMVHZHtUihUC0eW.BW8U38P.1_FX
 tvLTFhwCY.RYgXH3MjydGBZ2jJK_Alp8jogHwUsH1lDfB4xzpFrcFGghVNIHmvvBrMBy1k_Olyoj
 5UaulKe377KFuxw54_RqOlNyjXHSnh72cqumhI735rbvmF9qwxxNBuS1j306T7kEAuo9i.3lb1xH
 Y1V3lfKs2dGad4eOQ3ueNMMrE4GygJWcEIA8D5L43k07KrO1U6.hSuEqkopI5WcWCHGitKCb00Ak
 .vQ60DEx4kXx0U74s_KTL.tdvv47l4YHdK60HP9N6rRUU4O5qt_eZxw--
X-Sonic-MF: <abdul.rahim@myyahoo.com>
X-Sonic-ID: 87d31a78-8c80-4d80-bee8-a391d60809c3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.sg3.yahoo.com with HTTP; Fri, 15 Nov 2024 11:24:35 +0000
Received: by hermes--production-sg3-5b7954b588-2czcw (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 30b2b63ae3584f58ae1ae168a243895b;
          Fri, 15 Nov 2024 11:24:33 +0000 (UTC)
From: Abdul Rahim <abdul.rahim@myyahoo.com>
To: xiubli@redhat.com,
	idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abdul Rahim <abdul.rahim@myyahoo.com>
Subject: [PATCH v2] ceph: Use strscpy() instead of strcpy()
Date: Fri, 15 Nov 2024 16:54:19 +0530
Message-ID: <20241115112419.11137-1-abdul.rahim@myyahoo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20241115112419.11137-1-abdul.rahim.ref@myyahoo.com>

strcpy() performs no bounds checking on the destination buffer. This
could result in linear overflows beyond the end of the buffer, leading
to all kinds of misbehaviors. [1]

this fixes checkpatch warning:
    WARNING: Prefer strscpy over strcpy

[1] : https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy
Signed-off-by: Abdul Rahim <abdul.rahim@myyahoo.com>
---
Changes since v1:
- Added third parameter in strscpy()
- Added comment to explain where the limit `NAME_MAX+1` is comming from
  as suggested by Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Link to v1: https://lore.kernel.org/lkml/20241111221037.92853-1-abdul.rahim@myyahoo.com/

The function __get_snap_name() is assigned to .get_name() from 
struct export_operations, when `ceph_snap(inode) != CEPH_NOSNAP`.
`struct export_operations` is comming from `include/linux/exportfs.h`,
and according to [1], the operation get_name assumes that the variable
`name` is pointing to a buffer of size NAME_MAX+1

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/exportfs.h?h=v6.12-rc7#n203

 fs/ceph/export.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 44451749c544..96421f2b6cec 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -452,7 +452,11 @@ static int __get_snap_name(struct dentry *parent, char *name,
 		goto out;
 	if (ceph_snap(inode) == CEPH_SNAPDIR) {
 		if (ceph_snap(dir) == CEPH_NOSNAP) {
-			strcpy(name, fsc->mount_options->snapdir_name);
+			/* .get_name() from struct export_operations assumes
+			 * that its 'name' parameter is pointing to a 
+			 * NAME_MAX+1 sized buffer */
+			strscpy(name, fsc->mount_options->snapdir_name,
+					NAME_MAX+1);
 			err = 0;
 		}
 		goto out;
-- 
2.43.0


