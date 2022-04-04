Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8BC4F1253
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Apr 2022 11:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354707AbiDDJuc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Apr 2022 05:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354620AbiDDJua (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Apr 2022 05:50:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6959338B;
        Mon,  4 Apr 2022 02:48:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB69D1F383;
        Mon,  4 Apr 2022 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649065709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYKyuHWgBcNpYQldkCNyaN6h5hkH+B1Z/4mvpos8ICE=;
        b=y0sx+ke5D0ANL7IlqR4fDnqzXCALPotFvk0w59B/VU1s5fjN9KlM9usfrG9snb91mDIwZt
        E/nfPmP39a8X7xXfazNpRJJCUkJdTM8q4QNuMC2B50n/tmdEpdA33swCORyVJw6tTEhFiK
        opMa5b/i803cZUhLvYEUyGwD8hNfsq4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649065709;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYKyuHWgBcNpYQldkCNyaN6h5hkH+B1Z/4mvpos8ICE=;
        b=ned7fJBKyrAAyV9Fu90j1XN0Za9dPjcuHkhb57+KNixbk3fs5Jn59ao0frXjP8ZNw4Gqe7
        L4T3OJis5dg8k1CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7116612FC5;
        Mon,  4 Apr 2022 09:48:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E+BtGO2+SmK2LgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 04 Apr 2022 09:48:29 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id c663538d;
        Mon, 4 Apr 2022 08:55:27 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] common/encrypt: allow the use of 'fscrypt:' as key prefix
References: <20220401104553.32036-1-lhenriques@suse.de>
        <YkdAfpN/YzAm18pl@gmail.com>
Date:   Mon, 04 Apr 2022 09:55:27 +0100
In-Reply-To: <YkdAfpN/YzAm18pl@gmail.com> (Eric Biggers's message of "Fri, 1
        Apr 2022 18:12:14 +0000")
Message-ID: <874k39b534.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Fri, Apr 01, 2022 at 11:45:53AM +0100, Lu=C3=ADs Henriques wrote:
>> fscrypt keys have used the $FSTYP as prefix.  However this format is bei=
ng
>> deprecated -- newer kernels already allow the usage of the generic
>> 'fscrypt:' prefix for ext4 and f2fs.  This patch allows the usage of this
>> new prefix for testing filesystems that have never supported the old
>> format, but keeping the $FSTYP prefix for filesystems that support it, so
>> that old kernels can be tested.
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  common/encrypt | 38 +++++++++++++++++++++++++++-----------
>>  1 file changed, 27 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/common/encrypt b/common/encrypt
>> index f90c4ef05a3f..897c97e0f6fa 100644
>> --- a/common/encrypt
>> +++ b/common/encrypt
>> @@ -250,6 +250,27 @@ _num_to_hex()
>>  	fi
>>  }
>>=20=20
>> +# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key d=
escriptor
>> +# hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6 and later) a=
lso allow
>> +# the common key prefix "fscrypt:" in addition to their filesystem-spec=
ific key
>> +# prefix ("ext4:", "f2fs:").  It would be nice to use the common key pr=
efix, but
>> +# for now use the filesystem- specific prefix for these 2 filesystems t=
o make it
>> +# possible to test older kernels, and the "fscrypt" prefix for anything=
 else.
>> +_get_fs_keyprefix()
>> +{
>> +	local prefix=3D""
>> +
>> +	case $FSTYP in
>> +	ext4|f2fs|ubifs)
>> +		prefix=3D"$FSTYP"
>> +		;;
>> +	*)
>> +		prefix=3D"fscrypt"
>> +		;;
>> +	esac
>> +	echo $prefix
>> +}
>
> ubifs can use the "fscrypt" prefix, since there was never a kernel that
> supported ubifs encryption but not the "fscrypt" prefix.  Also, the "pref=
ix"
> local variable is unnecessary.  So:
>
> 	case $FSTYP in
> 	ext4|f2fs)
> 		echo $FSTYP
> 		;;
> 	*)
> 		echo fscrypt
> 		;;
> 	esac
>
> Otherwise, this patch looks fine if we want to keep supporting testing ke=
rnels
> older than 4.8.  However, since 4.4 is no longer a supported LTS kernel, =
perhaps
> this is no longer needed and we could just always use "fscrypt"?  I'm not=
 sure
> what xfstests's policy on old kernels is.

Thank you for your feedback.  I'll resend the patch with your changes.  I
am, of course, OK dropping support for older kernels on fstests, but I'll
leave that decision for the maintainers; if anyone thinks that support
should be dropped, I can send another version of the patch doing that.

Cheers,
--=20
Lu=C3=ADs
