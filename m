Return-Path: <ceph-devel+bounces-4077-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C25AC6129C
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Nov 2025 11:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C747A3A1CBA
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Nov 2025 10:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767C5286D55;
	Sun, 16 Nov 2025 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="0BUuM5Pn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3BE2857FA
	for <ceph-devel@vger.kernel.org>; Sun, 16 Nov 2025 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763289421; cv=none; b=eUGaj5sG95CQetCljQ5RUQRF5SqJcgbWcGKZ9rbqxcb38naZ0MDVgytDbWY3f1iC1ibOoyQj5po/xf1T8Rx8lsGtkjSUSm2KTikUvbxPqG54W/eJonkiSGwygMdH+/9rllJkcOGwbi/pbupD68hzhegb8Y6eAAk80wPl3pokN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763289421; c=relaxed/simple;
	bh=kiMW/IlmMt/llpJ0AhPrTQEfxQWr9GmclWgSQXm5Qj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEleiinnt1ztNrQMxfVDOfNggC4uZPHz25fqHsdoHK50Ha+kWbxyNJdCMf/Oi+loVuKT5njNOawThoOZU2TXUAGr5Y2RIhQFGEKHOhI0Jd9nlEcvU7G6hwkBzki1Dgci5fsAidu1J0k4Nbz9iolbW6FKH7jNq2OjwCy5bna2MDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=0BUuM5Pn; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so3779473b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 16 Nov 2025 02:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763289419; x=1763894219; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2xccyQL0wjRPHWCif7a/agPdP0N/MqlaSpRLb12d9w=;
        b=0BUuM5PncpIX4gC72ZeBeqGAoVm7WJWoHsc7iHU03TPriGYBKAi5KN+kdt8X96Aaom
         U51fdxYMHFpgFsHS/oICqBiwHnsCt5IQ6ipcG2r7bQw848z+A4HwViqmq+a8kDApLX5V
         rsTX+ceUU6uWaoxtowFDJ0BsfKmKhhOsVwB5YCiipkwMCatrxKoUBznXokuBrUlcdWWL
         YEyWZXmDIy5/2r1iIAgRGr8u7HtXRcODi8B+xSPKq6izhnh+H2I+23gI7hQ6aw1Jwe1V
         6ySC4MZS0LmjMmwTnu44iaLwlQDXjjf0/XMJFZbMz9S0LYCnh/qVUgjWrrnKwnfOA3Vd
         2U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763289419; x=1763894219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2xccyQL0wjRPHWCif7a/agPdP0N/MqlaSpRLb12d9w=;
        b=V13BYSSDdRekU1zjqFPdiWbVSMiiPxPdzEBFEQzczVFpMXcEkDfVDrCUC+o4KmO/od
         a+aUyPWWRKARp1GpQbytD02/6HgF+wKKRDdg8vWeJcVI3HzD11T+c6G/rxwcHvLG1W8J
         +DGMPqnlemMMmpU4wqrM2hyQAYhqg39LdMyvFH0R/i4BpznXdupTkTRrgLv5T4eKeAx+
         u4IyA1VGgXAk5/1P8ALCD380Tu3fy8D4hPKuQXloACbVN6OLTT8nw9eMgPqKg9AEkVie
         bc0aYT0GNGP3Qfk1q0Ppda74HhFAEtvlZ1NOEFmShc8P1b1OS/cWeGP2XG9hMiPI0ThW
         vNrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzbfyoI1DOyk3IkRmtEdVSh6KOpgiYB2ed1XJSmfZQDsf7EF8OFew5gBmAgwhHp/QXaoXJiPaQu5CQ@vger.kernel.org
X-Gm-Message-State: AOJu0YywIDbx/F7L39+K9hHfUetf9n//Of9T4t9RsBeUN02UORM74GZr
	4rsJETWCFV15yA7q2RDiOV59ziE/M8+m57aGUssu44Gr1Tlieu8wqmrlfd49GJPDG6Y=
X-Gm-Gg: ASbGncuAok5f8W0CCPhkGdy/m0V1DPqQ30Zj9ZqZuH65OWbJJ8P0o3pEqjJegJTY3Mv
	NuZUP5v26iv8D1cURoN9vWcZ06awO0VT62neKFhD1Rh0KUlKN52kztt7ObZwrg3Gsjyu+ju4Hz0
	Hdt8494TwXbFszYHm3HRpski34HQXSjyxUY4bBTiZc5USKeqbWVawDiGFw/Udqc6lEocH8Ev9aJ
	1UAKPvW9tGWCsWauhfWXJgH3HY8iUaoTVFYZuL+xSf0Q2oN5V5+3NlJzUvG0CZniUsoBf33EV6N
	zLE7ijlX4PFeyj6Hjj+s2xCFC2i2eFAlY/zFsqixLatk5vOgcBk27qCqr5Km9jiApx8TqsAnFtE
	qAuhnm24I03ydwPz7KPywZqntNmEZEezW9201scdvvAvhTKDVrwU72BUWC6bHxytVQoJ0+r7zFC
	N75oRH8aZ6nZNTR7MQs7bbw0Z5Rdsy45Zv
X-Google-Smtp-Source: AGHT+IEnf43Ltm/bA4lzbDQv+6sO2UhNpxxLrJK2n5FBPc4EJRJYJDkn08A4bHCQNvaKnyZ/h6JUVw==
X-Received: by 2002:a05:6a20:7d9d:b0:35c:e441:e6d2 with SMTP id adf61e73a8af0-35ce441e898mr7014829637.7.1763289418602;
        Sun, 16 Nov 2025 02:36:58 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:22b3:6dbf:5b14:3737])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36fa02c42sm9507887a12.16.2025.11.16.02.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 02:36:58 -0800 (PST)
Date: Sun, 16 Nov 2025 18:36:50 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	Xiubo Li <xiubli@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
	"hch@lst.de" <hch@lst.de>,
	"home7438072@gmail.com" <home7438072@gmail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"visitorckw@gmail.com" <visitorckw@gmail.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH v5 6/6] ceph: replace local base64 helpers with lib/base64
Message-ID: <aRmpQmMtfZQ8f95s@wu-Pro-E500-G6-WS720T>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
 <20251114060240.89965-1-409411716@gms.tku.edu.tw>
 <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>

On Fri, Nov 14, 2025 at 06:07:26PM +0000, Viacheslav Dubeyko wrote:
> On Fri, 2025-11-14 at 14:02 +0800, Guan-Chun Wu wrote:
> > Remove the ceph_base64_encode() and ceph_base64_decode() functions and
> > replace their usage with the generic base64_encode() and base64_decode()
> > helpers from lib/base64.
> > 
> > This eliminates the custom implementation in Ceph, reduces code
> > duplication, and relies on the shared Base64 code in lib.
> > The helpers preserve RFC 3501-compliant Base64 encoding without padding,
> > so there are no functional changes.
> > 
> > This change also improves performance: encoding is about 2.7x faster and
> > decoding achieves 43-52x speedups compared to the previous local
> > implementation.
> > 
> > Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  fs/ceph/crypto.c | 60 ++++--------------------------------------------
> >  fs/ceph/crypto.h |  6 +----
> >  fs/ceph/dir.c    |  5 ++--
> >  fs/ceph/inode.c  |  2 +-
> >  4 files changed, 9 insertions(+), 64 deletions(-)
> > 
> > diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> > index 7026e794813c..b6016dcffbb6 100644
> > --- a/fs/ceph/crypto.c
> > +++ b/fs/ceph/crypto.c
> > @@ -15,59 +15,6 @@
> >  #include "mds_client.h"
> >  #include "crypto.h"
> >  
> > -/*
> > - * The base64url encoding used by fscrypt includes the '_' character, which may
> > - * cause problems in snapshot names (which can not start with '_').  Thus, we
> > - * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
> > - * which replaces '-' and '_' by '+' and ','.
> > - */
> > -static const char base64_table[65] =
> > -	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
> > -
> > -int ceph_base64_encode(const u8 *src, int srclen, char *dst)
> > -{
> > -	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> > -	char *cp = dst;
> > -
> > -	for (i = 0; i < srclen; i++) {
> > -		ac = (ac << 8) | src[i];
> > -		bits += 8;
> > -		do {
> > -			bits -= 6;
> > -			*cp++ = base64_table[(ac >> bits) & 0x3f];
> > -		} while (bits >= 6);
> > -	}
> > -	if (bits)
> > -		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > -	return cp - dst;
> > -}
> > -
> > -int ceph_base64_decode(const char *src, int srclen, u8 *dst)
> > -{
> > -	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> > -	u8 *bp = dst;
> > -
> > -	for (i = 0; i < srclen; i++) {
> > -		const char *p = strchr(base64_table, src[i]);
> > -
> > -		if (p == NULL || src[i] == 0)
> > -			return -1;
> > -		ac = (ac << 6) | (p - base64_table);
> > -		bits += 6;
> > -		if (bits >= 8) {
> > -			bits -= 8;
> > -			*bp++ = (u8)(ac >> bits);
> > -		}
> > -	}
> > -	if (ac & ((1 << bits) - 1))
> > -		return -1;
> > -	return bp - dst;
> > -}
> > -
> >  static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
> >  {
> >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > @@ -318,7 +265,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
> >  	}
> >  
> >  	/* base64 encode the encrypted name */
> > -	elen = ceph_base64_encode(cryptbuf, len, p);
> > +	elen = base64_encode(cryptbuf, len, p, false, BASE64_IMAP);
> >  	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
> >  
> >  	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
> > @@ -412,7 +359,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
> >  			tname = &_tname;
> >  		}
> >  
> > -		declen = ceph_base64_decode(name, name_len, tname->name);
> > +		declen = base64_decode(name, name_len,
> > +				       tname->name, false, BASE64_IMAP);
> >  		if (declen <= 0) {
> >  			ret = -EIO;
> >  			goto out;
> > @@ -426,7 +374,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
> >  
> >  	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
> >  	if (!ret && (dir != fname->dir)) {
> > -		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
> > +		char tmp_buf[BASE64_CHARS(NAME_MAX)];
> >  
> >  		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
> >  				    oname->len, oname->name, dir->i_ino);
> > diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> > index 23612b2e9837..b748e2060bc9 100644
> > --- a/fs/ceph/crypto.h
> > +++ b/fs/ceph/crypto.h
> > @@ -8,6 +8,7 @@
> >  
> >  #include <crypto/sha2.h>
> >  #include <linux/fscrypt.h>
> > +#include <linux/base64.h>
> >  
> >  #define CEPH_FSCRYPT_BLOCK_SHIFT   12
> >  #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
> > @@ -89,11 +90,6 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
> >   */
> >  #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
> >  
> > -#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
> > -
> > -int ceph_base64_encode(const u8 *src, int srclen, char *dst);
> > -int ceph_base64_decode(const char *src, int srclen, u8 *dst);
> > -
> >  void ceph_fscrypt_set_ops(struct super_block *sb);
> >  
> >  void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index d18c0eaef9b7..0fa7c7777242 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -998,13 +998,14 @@ static int prep_encrypted_symlink_target(struct ceph_mds_request *req,
> >  	if (err)
> >  		goto out;
> >  
> > -	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
> > +	req->r_path2 = kmalloc(BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
> >  	if (!req->r_path2) {
> >  		err = -ENOMEM;
> >  		goto out;
> >  	}
> >  
> > -	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
> > +	len = base64_encode(osd_link.name, osd_link.len,
> > +			    req->r_path2, false, BASE64_IMAP);
> >  	req->r_path2[len] = '\0';
> >  out:
> >  	fscrypt_fname_free_buffer(&osd_link);
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index a6e260d9e420..b691343cb7f1 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -958,7 +958,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
> >  	if (!sym)
> >  		return -ENOMEM;
> >  
> > -	declen = ceph_base64_decode(encsym, enclen, sym);
> > +	declen = base64_decode(encsym, enclen, sym, false, BASE64_IMAP);
> >  	if (declen < 0) {
> >  		pr_err_client(cl,
> >  			"can't decode symlink (%d). Content: %.*s\n",
> 
> Looks good!
> 
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> 
> Have you run xfstests for this patchset?

Hi Slava,

Thanks for the review.

I haven't run xfstests on this patchset yet.

Best regards,
Guan-Chun

> 
> Thanks,
> Slava.

