Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46FB25074F
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 20:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHXSVR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 14:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgHXSVQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 14:21:16 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FA820738;
        Mon, 24 Aug 2020 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598293275;
        bh=BPd9FqfRK57acJvZfHNixoCcKstFE02QTmcYRlfCq7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gSO2JDEBH2du9sVIqRO/ccvceJM7cC9d3CT0/1d7x0lyj5q9qdZRvB77EudGgmLBP
         DDXy3fjKwWLf31wIq1ym4KVx7/HdPpObHPD4gbEQTGggArK1CPr0EOlxDk/XQs4GGp
         MxEUAJwlx/5dWcs35/gGQek/09sGDl96J76TPivQ=
Date:   Mon, 24 Aug 2020 11:21:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] fscrypt: add fscrypt_prepare_new_inode() and
 fscrypt_set_context()
Message-ID: <20200824182114.GB1650861@gmail.com>
References: <20200824061712.195654-1-ebiggers@kernel.org>
 <20200824061712.195654-2-ebiggers@kernel.org>
 <0cf5638796e7cddacc38dcd1e967368b99f0069a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf5638796e7cddacc38dcd1e967368b99f0069a.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 24, 2020 at 12:48:48PM -0400, Jeff Layton wrote:
> > +void fscrypt_hash_inode_number(struct fscrypt_info *ci,
> > +			       const struct fscrypt_master_key *mk)
> > +{
> > +	WARN_ON(ci->ci_inode->i_ino == 0);
> > +	WARN_ON(!mk->mk_ino_hash_key_initialized);
> > +
> > +	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
> > +					      &mk->mk_ino_hash_key);
> 
> i_ino is an unsigned long. Will this produce a consistent results on
> arches with 32 and 64 bit long values? I think it'd be nice to ensure
> that we can access an encrypted directory created on a 32-bit host from
> (e.g.) a 64-bit host.

The result is the same regardless of word size and endianness.
siphash_1u64(v, k) is equivalent to:

	__le64 x = cpu_to_le64(v);
	siphash(&x, 8, k);

> It may be better to base this on something besides i_ino

This code that hashes the inode number is only used when userspace used
FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 for the directory.  IV_INO_LBLK_32 modifies
the encryption to be optimized for eMMC inline encryption hardware.  For more
details, see commit e3b1078bedd3 which added this feature.

We actually could have hashed the file nonce instead of the inode number.  But I
wanted to make the eMMC-optimized format similar to IV_INO_LBLK_64, which is the
format optimized for UFS inline encryption hardware.

Both of these flags have very specific use cases; they make it feasible to use
inline encryption hardware
(https://www.kernel.org/doc/html/latest/block/inline-encryption.html)
that only supports a small number of keyslots and that limits the IV length.

You don't need to worry about these flags at all for ceph, since there won't be
any use case to use them on ceph, and ceph won't be declaring support for them.

- Eric
