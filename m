Return-Path: <ceph-devel+bounces-3837-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E140FBD6358
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Oct 2025 22:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37257421D85
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Oct 2025 20:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75FD311958;
	Mon, 13 Oct 2025 20:35:37 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.redxen.eu (el-tigre.venezuela.redxen.eu [138.199.230.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0930C375
	for <ceph-devel@vger.kernel.org>; Mon, 13 Oct 2025 20:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=138.199.230.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760387737; cv=none; b=olplVTpCUUab5Muo1+f1oAVWxPaRT7Ds15lR9cr1xr1V3yo/TOuWhhb4YD6zhq2K+4yuZFXDKd+GjF4kR+AogBN1dNuKaJAe/0b+zO6W9IGbpFWXBSmVdO763dYYgcUkYaWR+tK1fsdroOKEW3BAt/32VCn2+grG8DXDnJ+T940=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760387737; c=relaxed/simple;
	bh=EP7R4uWZiC7U2AZTgtbBY/iBSGDrwo4exE3TT+xzsL8=;
	h=Date:To:Subject:From:Message-Id:MIME-Version:Content-Type; b=gLbeRq6RBEb1VRspTmnhmt7/IJ+e7842IeTa0AQi0GoBe7GVvgQqA1oTvL7US3VvxFRySjlQAWGIoINsDBBNSuaNtGQO0+XuNa7OuaaNgOTY/mpClLQ8vl1V+yFGBE7pKhu48RA08/KejORQAJ99uIEhRthjNyZ4KEeDl/zj9+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redxen.eu; spf=pass smtp.mailfrom=redxen.eu; arc=none smtp.client-ip=138.199.230.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redxen.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redxen.eu
Received: from localhost (karaj.iran.redxen.eu [91.107.235.83])
	by smtp.redxen.eu (RedXen Mail Postfix) with UTF8SMTPSA id 80FA831
	for <ceph-devel@vger.kernel.org>; Mon, 13 Oct 2025 20:35:23 +0000 (UTC)
Authentication-Results: smtp.redxen.eu;
	auth=pass smtp.auth=caskd smtp.mailfrom=caskd@redxen.eu
Date: Mon, 13 Oct 2025 20:35:22 +0000
To: ceph-devel@vger.kernel.org
Subject: [bug report] listing cephfs snapshots causes general protection
 fault
From: caskd <caskd@redxen.eu>
Message-Id: <2XRKV3P9QNXDI.37IHX7CVTJ6SD@unix.is.love.unix.is.life>
User-Agent: mblaze/1.3
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="----_=_1f9b77a17fee1ba153ac2880_=_"

This is a multipart message in MIME format.

------_=_1f9b77a17fee1ba153ac2880_=_
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_7836636542de35a700fc6891_=_"

This is a multipart message in MIME format.

------_=_7836636542de35a700fc6891_=_
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Ceph developers,

i've encountered a bug on Squid 19.2.3 with the cephfs kernel client.

Listing the snapshot of any directory causes the kernel to access invalid/u=
nexpected address.=20

# Logs and further information:


------_=_7836636542de35a700fc6891_=_
Content-Disposition: attachment; filename=klog.txt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

kern.warn: [581015.841007] Oops: general protection fault, probably for non=
-canonical address 0x5d2ecc0680000000: 0000 [#1] PREEMPT SMP PTI
kern.warn: [581015.844081] CPU: 1 UID: 0 PID: 3825461 Comm: kworker/1:3 Not=
 tainted 6.12.43-0-virt #1-Alpine
kern.warn: [581015.846230] Hardware name: QEMU Standard PC (Q35 + ICH9, 200=
9), BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
kern.warn: [581015.849810] Workqueue: ceph-msgr ceph_con_workfn [libceph]
kern.warn: [581015.852352] RIP: 0010:rb_insert_color+0xa4/0x170
kern.warn: [581015.854292] Code: 31 f6 31 ff 45 31 c0 c3 cc cc cc cc 48 89 =
06 31 c0 31 d2 31 c9 31 f6 31 ff 45 31 c0 c3 cc cc cc cc 48 8b 51 10 48 85 =
d2 74 05 <f6> 02 01 74 1b 48 8b 50 10 48 39 fa 74 75 48 89 c7 48 89 51 08 4=
8
kern.warn: [581015.861182] RSP: 0000:ffffbab5cbf9fa08 EFLAGS: 00010206
kern.warn: [581015.863069] RAX: ffff8f5d2ecc0c40 RBX: ffff8f5d2ecc0000 RCX:=
 ffff8f5d2ecc0ad0
kern.warn: [581015.865096] RDX: 5d2ecc0680000000 RSI: ffff8f5d47e64da0 RDI:=
 ffff8f5d2ecc0380
kern.warn: [581015.866517] RBP: 0000000000005595 R08: 0000000000000000 R09:=
 0000000000000000
kern.warn: [581015.867908] R10: ffff8f5d2ecc0680 R11: 0000000000000000 R12:=
 ffff8f5d47e64d98
kern.warn: [581015.869309] R13: ffff8f5d47d30000 R14: ffff8f5d2ecc0680 R15:=
 ffff8f5d47e64da0
kern.warn: [581015.871406] FS:  0000000000000000(0000) GS:ffff8f645fc40000(=
0000) knlGS:0000000000000000
kern.warn: [581015.872992] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
kern.warn: [581015.874178] CR2: 00007fe0accea180 CR3: 00000002e5ab0006 CR4:=
 0000000000172eb0
kern.warn: [581015.875475] Call Trace:
kern.warn: [581015.875948]  <TASK>
kern.warn: [581015.876366]  ceph_get_snapid_map+0x125/0x300 [ceph]
kern.warn: [581015.877432]  ceph_fill_inode+0x1015/0x14a0 [ceph]
kern.warn: [581015.878288]  ceph_readdir_prepopulate+0x34d/0xe40 [ceph]
kern.warn: [581015.879220]  mds_dispatch+0x1b2f/0x1ec0 [ceph]
kern.warn: [581015.880024]  ? gcm_decrypt_aesni_avx+0x1e7/0x270 [aesni_inte=
l]
kern.warn: [581015.881054]  ceph_con_process_message+0x72/0x140 [libceph]
kern.warn: [581015.882022]  process_message+0x9/0x110 [libceph]
kern.warn: [581015.882856]  ceph_con_v2_try_read+0xb3b/0x1830 [libceph]
kern.warn: [581015.883820]  ? set_next_entity+0xf1/0x200
kern.warn: [581015.884552]  ? __schedule+0x3c3/0x1540
kern.warn: [581015.885250]  ceph_con_workfn+0x140/0x650 [libceph]
kern.warn: [581015.886107]  process_one_work+0x173/0x330
kern.warn: [581015.886857]  worker_thread+0x259/0x390
kern.warn: [581015.887514]  ? __pfx_worker_thread+0x10/0x10
kern.warn: [581015.888264]  kthread+0xcd/0x100
kern.warn: [581015.888865]  ? __pfx_kthread+0x10/0x10
kern.warn: [581015.889521]  ret_from_fork+0x2f/0x50
kern.warn: [581015.890195]  ? __pfx_kthread+0x10/0x10
kern.warn: [581015.890858]  ret_from_fork_asm+0x1a/0x30
kern.warn: [581015.891565]  </TASK>
kern.warn: [581015.891983] Modules linked in: overlay rbd nft_reject_inet n=
f_reject_ipv4 nf_reject_ipv6 nft_reject nft_chain_nat nf_nat mousedev nft_f=
ib_ipv4 kvm_intel tiny_power_button psmouse evdev efi_pstore qemu_fw_cfg bu=
tton nft_ct nls_utf8 nf_conntrack nls_cp437 nf_defrag_ipv6 nf_defrag_ipv4 n=
ft_fib_ipv6 nft_fib nf_tables kvm af_packet irqbypass sch_fq_codel ext4 wir=
eguard ceph curve25519_x86_64 libchacha20poly1305 chacha_x86_64 poly1305_x8=
6_64 ip6_udp_tunnel crc16 libceph udp_tunnel mbcache bridge libcurve25519_g=
eneric nfnetlink vfat netfs jbd2 fuse stp tun libchacha llc fat dm_crypt en=
crypted_keys dm_mod virtio_balloon virtio_gpu virtio_dma_buf virtio_blk vir=
tio_rng rng_core virtio_net net_failover failover crct10dif_pclmul crc32_pc=
lmul ghash_clmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3 sha1_generic =
aesni_intel gf128mul crypto_simd cryptd xhci_pci xhci_hcd usbcore usb_commo=
n simpledrm drm_shmem_helper syscopyarea sysfillrect sysimgblt fb_sys_fops =
drm_kms_helper drm i2c_core drm_panel_orientation_quirks fb loop btrfs
kern.warn: [581015.892392]  blake2b_generic libcrc32c crc32c_generic crc32c=
_intel xor raid6_pq
kern.warn: [581015.907981] ---[ end trace 0000000000000000 ]---
kern.warn: [581017.966077] clocksource: Long readout interval, skipping wat=
chdog check: cs_nsec: 2118959053 wd_nsec: 2118958425
kern.warn: [581017.969353] RIP: 0010:rb_insert_color+0xa4/0x170
kern.warn: [581017.972504] Code: 31 f6 31 ff 45 31 c0 c3 cc cc cc cc 48 89 =
06 31 c0 31 d2 31 c9 31 f6 31 ff 45 31 c0 c3 cc cc cc cc 48 8b 51 10 48 85 =
d2 74 05 <f6> 02 01 74 1b 48 8b 50 10 48 39 fa 74 75 48 89 c7 48 89 51 08 4=
8
kern.warn: [581017.976473] RSP: 0000:ffffbab5cbf9fa08 EFLAGS: 00010206
kern.warn: [581017.977392] RAX: ffff8f5d2ecc0c40 RBX: ffff8f5d2ecc0000 RCX:=
 ffff8f5d2ecc0ad0
kern.warn: [581017.978583] RDX: 5d2ecc0680000000 RSI: ffff8f5d47e64da0 RDI:=
 ffff8f5d2ecc0380
kern.warn: [581017.979912] RBP: 0000000000005595 R08: 0000000000000000 R09:=
 0000000000000000
kern.warn: [581017.981156] R10: ffff8f5d2ecc0680 R11: 0000000000000000 R12:=
 ffff8f5d47e64d98
kern.warn: [581017.982354] R13: ffff8f5d47d30000 R14: ffff8f5d2ecc0680 R15:=
 ffff8f5d47e64da0
kern.warn: [581017.983666] FS:  0000000000000000(0000) GS:ffff8f645fc40000(=
0000) knlGS:0000000000000000
kern.warn: [581017.985059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
kern.warn: [581017.986020] CR2: 00007fe0accea180 CR3: 00000002e5ab0006 CR4:=
 0000000000172eb0
kern.info: [581017.987213] note: kworker/1:3[3825461] exited with preempt_c=
ount 1

------_=_7836636542de35a700fc6891_=_
Content-Disposition: attachment; filename=mds-metadata.txt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

{
    "addr": "v2:REDACTED:6801/REDACTED",
    "arch": "x86_64",
    "ceph_release": "squid",
    "ceph_version": "ceph version 19.2.3 (c92aebb279828e9c3c1f5d24613efca27=
2649e62) squid (stable)",
    "ceph_version_short": "19.2.3",
    "cpu": "Intel(R) Xeon(R) CPU E5-2470 v2 @ 2.40GHz",
    "distro": "nnd",
    "distro_description": "nonamedistribution 1.0",
    "distro_version": "1.0",
    "hostname": "la-orilla.mexico",
    "kernel_description": "#1-Alpine SMP PREEMPT_DYNAMIC 2025-10-02 13:09:5=
1",
    "kernel_version": "6.12.50-0-virt",
    "mem_swap_kb": "0",
    "mem_total_kb": "164821204",
    "os": "Linux"
}

------_=_7836636542de35a700fc6891_=_
Content-Disposition: attachment; filename=fs-metadata.txt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

e1041500
btime 2025-10-13T19:11:24:543289+0000
enable_multiple, ever_enabled_multiple: 1,1
default compat: compat=3D{},rocompat=3D{},incompat=3D{1=3Dbase v0.20,2=3Dcl=
ient writeable ranges,3=3Ddefault file layouts on dirs,4=3Ddir inode in sep=
arate object,5=3Dmds uses versioned encoding,6=3Ddirfrag is stored in omap,=
8=3Dno anchor table,9=3Dfile layout v2,10=3Dsnaprealm v2}
legacy client fscid: -1
=20
#### 2 FILESYSTEMS REDACTED ####=20
=20
Filesystem 'caskd' (16)
fs_name	caskd
epoch	1041500
flags	12 joinable allow_snaps allow_multimds_snaps
created	2025-10-03T18:06:16.720334+0000
modified	2025-10-13T19:11:24.492967+0000
tableserver	0
root	0
session_timeout	60
session_autoclose	300
max_file_size	1099511627776
max_xattr_size	65536
required_client_features	{}
last_failure	0
last_failure_osd_epoch	0
compat	compat=3D{},rocompat=3D{},incompat=3D{1=3Dbase v0.20,2=3Dclient writ=
eable ranges,3=3Ddefault file layouts on dirs,4=3Ddir inode in separate obj=
ect,5=3Dmds uses versioned encoding,6=3Ddirfrag is stored in omap,7=3Dmds u=
ses inline data,8=3Dno anchor table,9=3Dfile layout v2,10=3Dsnaprealm v2,11=
=3Dminor log segments,12=3Dquiesce subvolumes}
max_mds	1
in	0
up	{0=3D368484109}
failed=09
damaged=09
stopped=09
data_pools	[106,105]
metadata_pool	107
inline_data	disabled
balancer=09
bal_rank_mask	-1
standby_count_wanted	1
qdb_cluster	leader: 368484109 members: 368484109
[mds.la-orilla.mexico.2{0:368484109} state up:active seq 217880 addr v2:RED=
ACTED:6801/REDACTED compat {c=3D[1],r=3D[1],i=3D[1fff]}]

------_=_7836636542de35a700fc6891_=_
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Mount spec:
admin@REDACTED.caskd=3D/ REDACTED ceph rw,relatime,name=3Dadmin,secret=3D<h=
idden>,ms_mode=3Dsecure,acl,mon_addr=3DREDACTED:3300/REDACTED:3300,recover_=
session=3Dclean 0 0

- snap-schedule is set up on / and the filesystem is heavily used
  - not many concurrent accesses to the same dir/inodes
- encountered on both 6.12 and 6.16 on multiple machines, including qemu
- i can replicate this every time with the kernel client but not with the F=
USE client

# Here is what i have tried so far.

- rebuild the filesystem from scratch to rule out potential inconsistent me=
tadata
  - bug has returned after a few days on the new fs

# Ways to replicate (UNCONFIRMED):

Create a cephfs filesystem
Setup snap-schedule with retention
Do heavy RW on filesystem while snapshot gets deleted
List .snap/

# Misc info

- The previous filesystem had the main pool on 3x replicated and this new o=
ne is ec 6-2 jerasure
  - This seems to play no role into this bug.
- I would be willing to narrow down the issue to the minimal reproducible e=
xample if this information is not enough.
- This filesystem contains a significant amount of small files and director=
ies if it plays any role.

Please let me know if you need any further information

--=20
Alex D.
RedXen System & Infrastructure Administration
https://redxen.eu/

------_=_7836636542de35a700fc6891_=_--

------_=_1f9b77a17fee1ba153ac2880_=_
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJEBAABCgAuFiEE2k4nnbsAOnatJfEW+SuoX2H0wXMFAmjtYocQHGNhc2tkQHJl
ZHhlbi5ldQAKCRD5K6hfYfTBc9JpD/wKJb5AAX2fT2ni8h5cc+ZcUn4EoxTEz6Tr
CKnE5HC4/PDO8WDsWhrCGajm6TbAnhSX/NogztAau9UTZrO+yqc70Sut32nC/LKy
InMiI5lcshXw+qHbfvxHp/aONQHYMYDdh5XR1D+C5Vzj3kDlyPXBf5hYtXY82BnE
Bq+MyNdsTvTE/mwQ5AolaYOoiw8O1wiPfV1FU2d62HuTi2hvTN01FBeOR53fd36W
csHFhiBaZXRTBCH15GRp3KVPF1bugJNqBnC5Z77x/uiJwpUXZfPu8pQQgpmA7Wol
fYuorCtFULIdfnBN/+lQO0EA+8EWClTUithlGrmRQQDra54MrxlkkAX0jEO8KGew
cZYBjvAjd0A6aj1XOIyCw10R92KncHenW2TeRuNEJ4iPCyWUvChV+Bf+zQuMAAwA
VbvTaXwTKvqeHdtnfwyFtYZ1WqWaqrqJL1DTlbyFD+FU4fy4Px+PE0QWeocHaujh
1Ju1tYggtCQPHujnPTWqSF3jCx/BnGOOBcZ2S6vgrB+woKq7g8U+Z6cSo/MXK8KA
ATykzGyjGiwNOsCmnOVYF3x6ZHZYQwt1+x4TfUs9St0FJdID2M2kONe3OB2+Wna6
cJzKFnk40Gapv/4rHrXkhmSK4yXxBhQd1KeNCXCBHllTIx8e7s+ezLJyEWu08AQ+
VnbCC6ti0g==
=PEfD
-----END PGP SIGNATURE-----

------_=_1f9b77a17fee1ba153ac2880_=_--

