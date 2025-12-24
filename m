Return-Path: <ceph-devel+bounces-4229-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 177F0CDD125
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 22:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AA2E3009417
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 21:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCE1329C56;
	Wed, 24 Dec 2025 21:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="0C49wLW/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F82116F6
	for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 21:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766610699; cv=none; b=pJRTmdrR7XdIcQuMo4FyPUlifIhX01roAzmsW1sFPK2FeyMOw9aOnaerELq9taXrXG6+P6paKbgx/VscjFw9/taCmCZtU8zsUjhWe4id3+7uFkj5wtq7q/I0oaD97GvlAh5yieO6+HUAgJkQVeAzY8ra8krk9uOE5fCL0Ey5nRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766610699; c=relaxed/simple;
	bh=zXZKG3n4UJYPcSKA+5hp0NjAStRO5ooAlX0gYolGMLE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AzZAwlFuFRGTH65NUxAbM/TV1RCFuhl68AmnZA05vdc3WiVN83bQr2zCdZGBvwqj/lmpdtzSiUaZb2GLyEp8xwshAguwyu78ipOA2TTrIBBxiQBMnmfcGm/8jWJjlwLrdclo/UDFrR90m1MzBq+r1ytJUkmTQTJa9PGJb5qFZAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=0C49wLW/; arc=none smtp.client-ip=74.125.224.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-6468f0d5b1cso1932794d50.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 13:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1766610696; x=1767215496; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWCFSD1cVEJKVPsEu8lJ2oiBtaL4sewpmskQrTIP4tU=;
        b=0C49wLW/ztIKkwIpv/T/tGBQ4RdSXy4CD1oosZ/0ueb9yvmxPlywmI1LQcxuVklqCY
         ZyDRHDe7Odnrti/Te2CX+mKYUxY/fEx9jXVzlTrCxaqdAbZoC9rebqZTS8TA6uvwXjQ1
         qDGqqI5O1fbj93xAZqLDcmQtppL5paH5hCGenYskgu5okffV64/a9CmlaGJjWe4OR9os
         zg4bItCKDCZO2g8QQ2dG7qMFBGL8h7Rc446aQaltianRyN8ERXcZBU+6pAmPMbz2o2y8
         eFWLto2yW1R64oc+rt4XEHETBA/GRAusNNX8E4QaDw3/hzrv3HAXQt3z6C4kZtXLTv4d
         VQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766610696; x=1767215496;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OWCFSD1cVEJKVPsEu8lJ2oiBtaL4sewpmskQrTIP4tU=;
        b=JvX+EO+Bt2xsOwwNVpNxPB+leGh85+LZt1TSJJbR61xu+593hChNRFaj5GpuYj+xgW
         oB5GVgJENxdddqrvMLjZwhvDiwJd889KEZ/Y0pjBNErA5aK00EzezCS+wcFR+RXw+Nir
         WAVlKaa7cQI/oGxaQ5riN6Zg6jQDj9UmN1sTDY/Umqy7niORDIR1nv/Kq+0QC++lFwum
         gZe2+sGx5XB+cuf0goot7HqTAXkuP2W6e47Zq8bQ/5hkWgtl2i6mxqXI7JlKt8RuOR55
         5MT8RDrXSKjb8UaDAOvL47Z6d8hoFnOeYiN5+rhva8rkUg7BMxta4yCZCTMlTduh4559
         6OVw==
X-Forwarded-Encrypted: i=1; AJvYcCWGdOF0wZ/46K+Lt7LLo1Pty4VCK1Nc+/Mq6Tfi0fmFrPi8UXQdXiCFUCOhooBVLP+epifHO6a4tCIL@vger.kernel.org
X-Gm-Message-State: AOJu0YzNbai6KYbQS9GITwYUs/84+caRhSdIY7i6P/BBNh1XMY8txyVD
	rLLeD8TFXp7OP22dNsZHl/0bh/sCbr6poyrXFZKAxWIyJLPBRrATPdZyGcgykmUCyRw=
X-Gm-Gg: AY/fxX41n4f+ZXSPvpT6MP1FlYxKMFJMLikJkM7ExAfsguvbKaQE67zJTBGzOf2stLV
	HgIwsc8Vi1QXWX/lt+veYG0z+YfNtOdL84t3al4bq90ykCQPlV6+uzadtMwjjvafUjCKLlB5Ibn
	1VLOmsjd/N09WzPAIzvBxf3OYPtfBIKKLyRoAip5z/pxLIqeiDEY49xE/xFx6TaHkqhxpFjd1XK
	PUAGPzCawyCpGWtOfKXojlf4CnGpe1K0owu8Ouc7uQ0slZeYuOCgyT4tid2FrOdsN3nsnvDHS4e
	VnQWos/uVz468gslFvmLvDAYP1y8agsIzVfpeQSjKTgi4DFnV4Vb47lYOBi2+/BGOlo6gu3eJf4
	GJmVyp2N9cRNEwaN/AdoSF/uyZv8vAVepwHmoSENqnIt3Dum99jtcOU7Lc5sfsFq2WbI74TR/if
	rkW21m+bZYpEBpIkrx1xNyx4lv6fhPiVb7fLL6I7aBbWWy3japnxVTlA+C2T0QlrQxCw5HuVFUf
	l+uzLN//1C3
X-Google-Smtp-Source: AGHT+IFCiYVVwUtxWCvJt3lFyEkexWHVVforf6ovlABYHb2osKC49KgnTfPfX9KDYPaCKvEXxiED2g==
X-Received: by 2002:a53:e10c:0:b0:636:d63e:5c1f with SMTP id 956f58d0204a3-6466a900ed7mr9714371d50.49.1766610695804;
        Wed, 24 Dec 2025 13:11:35 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:1a1b:935a:b867:b56f])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a8b1948sm8747580d50.5.2025.12.24.13.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 13:11:35 -0800 (PST)
Message-ID: <14583623641f27955592ae17dfcd88c0418ac289.camel@dubeyko.com>
Subject: Re: [PATCH] ceph: add support for multi-stream SSDs(such as FDP
 SSDs)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Qian Li <qian01.li@samsung.com>, idryomov@gmail.com, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org
Date: Wed, 24 Dec 2025 13:11:33 -0800
In-Reply-To: <20251224101544.3057791-1-qian01.li@samsung.com>
References: 
	<CGME20251224023403epcas5p16c061413b711b019c9cd63441bae985f@epcas5p1.samsung.com>
	 <20251224101544.3057791-1-qian01.li@samsung.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-12-24 at 18:15 +0800, Qian Li wrote:
> The NVMe SSD (e.g. Flexible Data Placement SSD, TP4146) is
> supporting to recognize data lifetime information on device.=C2=A0

As far as I know, FDP SSD itself cannot recognize data lifetime. This
device is stupid enough. It needs to receive the hints from application
or file system to distribute data in different streams based on
"temperature" hints.

> It
> provides multiple streams to isolate different data lifetimes.
> Write_hint support in fs and block layers has been available since
> commit 449813515d3e ("block, fs: restore per-bio/request
> data lifetime field").
> This patch enables the Ceph kernel client to support
> the data lifetime field and to transmit the write_hint
> to the Ceph server over the network. By adding the write_hint to
> Ceph and passing it to the device, we achieve lower write
> amplification and better performance.

What is your prove that you can achieve lower write
amplification and better performance? Do you have any benchmark
results?

Currently, I am not convinced at all that suggested approach can work.
You provide hints for inode (inode->i_write_hint), then it means that
you share it on file basis. If it is small file(s), then one object
could receive multiple files with various temperature hints. If it is
huge file, then multiple objects on various OSDs can store file
content. OSD is a thing in itself and CRUSH algorithm defines which OSD
receives some object. Also, replication and redistribution algorithms
can move and shift data among OSDs that complicates data distribution a
lot.

First of all, this complicated environment doesn't guarantee simple
model of data placement. And even if you provide the "temperature"
hints for the files, then OSD will have a complete mess of these hints
for objects. Also, object is a big piece of data (around 4MB) and, as a
result, if you write it sequentially and use COW policy, then you don't
need in likewise hints at all. Secondly, as far as I can see, people
could use HDDs for Ceph clusters. And it means that FDP will be
completely useless in such case.

So, I would like to see a really good research that can prove that
suggested concept can really work. Otherwise, this patch is completely
useless.


> We have implemented a complete feature for multi-stream devices
> such as FDP SSDs (client + server). The corresponding Ceph
> server patch can be found in the pull request here:
> https://github.com/ceph/ceph/pull/66716
>=20
> Signed-off-by: Qian Li <qian01.li@samsung.com>
> ---
> =C2=A0fs/ceph/addr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 ++
> =C2=A0fs/ceph/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 4 +++-
> =C2=A0include/linux/ceph/ceph_fs.h=C2=A0=C2=A0=C2=A0 | 1 +
> =C2=A0include/linux/ceph/osd_client.h | 2 +-
> =C2=A0net/ceph/osd_client.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 5 ++++-
> =C2=A05 files changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 322ed268f14a..94a99e26f455 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -778,6 +778,7 @@ static int write_folio_nounlock(struct folio
> *folio,
> =C2=A0	=C2=A0=C2=A0=C2=A0 CONGESTION_ON_THRESH(fsc->mount_options->conges=
tion_kb))
> =C2=A0		fsc->write_congested =3D true;
> =C2=A0
> +	ci->i_layout.write_hint =3D inode->i_write_hint;
> =C2=A0	req =3D ceph_osdc_new_request(osdc, &ci->i_layout,
> ceph_vino(inode),
> =C2=A0				=C2=A0=C2=A0=C2=A0 page_off, &wlen, 0, 1,
> CEPH_OSD_OP_WRITE,
> =C2=A0				=C2=A0=C2=A0=C2=A0 CEPH_OSD_FLAG_WRITE, snapc,
> @@ -1427,6 +1428,7 @@ int ceph_submit_write(struct address_space
> *mapping,
> =C2=A0new_request:
> =C2=A0	offset =3D ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
> =C2=A0	len =3D ceph_wbc->wsize;
> +	ci->i_layout.write_hint =3D inode->i_write_hint;
> =C2=A0
> =C2=A0	req =3D ceph_osdc_new_request(&fsc->client->osdc,
> =C2=A0				=C2=A0=C2=A0=C2=A0 &ci->i_layout, vino,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 99b30f784ee2..5063f9d9f30c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1518,6 +1518,7 @@ ceph_direct_read_write(struct kiocb *iocb,
> struct iov_iter *iter,
> =C2=A0	} else {
> =C2=A0		flags =3D CEPH_OSD_FLAG_READ;
> =C2=A0	}
> +	ci->i_layout.write_hint =3D inode->i_write_hint;
> =C2=A0
> =C2=A0	while (iov_iter_count(iter) > 0) {
> =C2=A0		u64 size =3D iov_iter_count(iter);
> @@ -1675,6 +1676,7 @@ ceph_direct_read_write(struct kiocb *iocb,
> struct iov_iter *iter,
> =C2=A0			req =3D list_first_entry(&osd_reqs,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct
> ceph_osd_request,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_private_item);
> +			req->write_hint =3D inode->i_write_hint;
> =C2=A0			list_del_init(&req->r_private_item);
> =C2=A0			if (ret >=3D 0)
> =C2=A0				ceph_osdc_start_request(req->r_osdc,
> req);
> @@ -1732,7 +1734,7 @@ ceph_sync_write(struct kiocb *iocb, struct
> iov_iter *from, loff_t pos,
> =C2=A0		return ret;
> =C2=A0
> =C2=A0	ceph_fscache_invalidate(inode, false);
> -
> +	ci->i_layout.write_hint =3D inode->i_write_hint;
> =C2=A0	while ((len =3D iov_iter_count(from)) > 0) {
> =C2=A0		size_t left;
> =C2=A0		int n;
> diff --git a/include/linux/ceph/ceph_fs.h
> b/include/linux/ceph/ceph_fs.h
> index c7f2c63b3bc3..61e175c21ca6 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -65,6 +65,7 @@ struct ceph_file_layout {
> =C2=A0	u32 object_size;=C2=A0=C2=A0 /* until objects are this big */
> =C2=A0	s64 pool_id;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* rados po=
ol id */
> =C2=A0	struct ceph_string __rcu *pool_ns; /* rados pool namespace
> */
> +	int32_t=C2=A0 write_hint;
> =C2=A0};
> =C2=A0
> =C2=A0extern int ceph_file_layout_is_valid(const struct ceph_file_layout
> *layout);
> diff --git a/include/linux/ceph/osd_client.h
> b/include/linux/ceph/osd_client.h
> index 50b14a5661c7..65db613339ef 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -278,7 +278,7 @@ struct ceph_osd_request {
> =C2=A0	ktime_t r_end_latency;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* ktime_t */
> =C2=A0	int r_attempts;
> =C2=A0	u32 r_map_dne_bound;
> -
> +	int32_t=C2=A0 write_hint;

The ceph_osd_request contains r_inode field. And inode has inode-
>i_write_hint. I am guessing do we really need to introduce write_hint
in struct ceph_osd_request and struct ceph_file_layout?

> =C2=A0	struct ceph_osd_req_op r_ops[] __counted_by(r_num_ops);
> =C2=A0};
> =C2=A0
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 3667319b949d..57cb3f9ada66 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -605,7 +605,7 @@ static int __ceph_osdc_alloc_messages(struct
> ceph_osd_request *req, gfp_t gfp,
> =C2=A0	msg_size +=3D 8; /* snapid */
> =C2=A0	msg_size +=3D 8; /* snap_seq */
> =C2=A0	msg_size +=3D 4 + 8 * (req->r_snapc ? req->r_snapc->num_snaps
> : 0);
> -	msg_size +=3D 4 + 8; /* retry_attempt, features */
> +	msg_size +=3D 4 + 4 + 8; /* retry_attempt, write_hint,
> features */

I really hate this hardcoded values. We should introduce nicely named
constants.

Thanks,
Slava.

> =C2=A0
> =C2=A0	if (req->r_mempool)
> =C2=A0		msg =3D ceph_msgpool_get(&osdc->msgpool_op, msg_size,
> @@ -1081,6 +1081,7 @@ struct ceph_osd_request
> *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> =C2=A0		goto fail;
> =C2=A0	}
> =C2=A0
> +	req->write_hint =3D layout->write_hint;
> =C2=A0	/* calculate max write size */
> =C2=A0	r =3D calc_layout(layout, off, plen, &objnum, &objoff,
> &objlen);
> =C2=A0	if (r)
> @@ -2194,6 +2195,8 @@ static void encode_request_partial(struct
> ceph_osd_request *req,
> =C2=A0	}
> =C2=A0
> =C2=A0	ceph_encode_32(&p, req->r_attempts); /* retry_attempt */
> +	ceph_encode_32(&p, req->write_hint);
> +
> =C2=A0	BUG_ON(p > end - 8); /* space for features */
> =C2=A0
> =C2=A0	msg->hdr.version =3D cpu_to_le16(8); /* MOSDOp v8 */

