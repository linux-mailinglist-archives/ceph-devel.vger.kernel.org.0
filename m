Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A763B4D2E80
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 12:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiCIL6r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 06:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiCIL6q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 06:58:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89283116C
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 03:57:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 469BC1F382;
        Wed,  9 Mar 2022 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646827066; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8IWpHCat/yOrDN6EEl+BwDA9VIAF/tZAbJiDugBQGAU=;
        b=RN6qYV08SVZ2ntsJ9ZmOaY7y56Q5Vrs1U9RR5hGhUrZmRysXEcl3b+Gw7rxWp0UIIBn29r
        XpnJi+W1MNakM1ly0kynj8XukVZz6jrkv497qA3jnI0GF1EFPmYtxD/UYLD+MKl3Bf1B7u
        xTRe3APllcN8t8EX2L0zsaweHVkL+fI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646827066;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8IWpHCat/yOrDN6EEl+BwDA9VIAF/tZAbJiDugBQGAU=;
        b=0+2WOQjALkLZjltuqR/2TjEnb4pLSb4qIQiyKVFX6FQC2UDUBRqJIQNFE929QdGfJXywFC
        g6JENHwjwUTmQ6Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E356913D79;
        Wed,  9 Mar 2022 11:57:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6AK0NDmWKGLscgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 09 Mar 2022 11:57:45 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 40658114;
        Wed, 9 Mar 2022 11:58:00 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for readdir
References: <20220305122527.1102109-1-xiubli@redhat.com>
        <87h788z67y.fsf@brahms.olymp>
        <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com>
        <87v8wn78jq.fsf@brahms.olymp>
        <84fc2bde-2fe8-ec78-1145-2cc010259f38@redhat.com>
Date:   Wed, 09 Mar 2022 11:58:00 +0000
In-Reply-To: <84fc2bde-2fe8-ec78-1145-2cc010259f38@redhat.com> (Xiubo Li's
        message of "Wed, 9 Mar 2022 18:11:25 +0800")
Message-ID: <87r17b72yf.fsf@brahms.olymp>
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

Xiubo Li <xiubli@redhat.com> writes:

> On 3/9/22 5:57 PM, Lu=C3=ADs Henriques wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>>> On 3/9/22 1:47 AM, Lu=C3=ADs Henriques wrote:
>>>> xiubli@redhat.com writes:
>>>>
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> For the readdir request the dentries will be pasred and dencrypted
>>>>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>>>>> get the dentry name from the dentry cache instead of parsing and
>>>>> dencrypting them again. This could improve performance.
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>
>>>>> V5:
>>>>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>>>>> - release the rde->dentry in destroy_reply_info
>>>>>
>>>>>
>>>>>    fs/ceph/crypto.h     |  8 ++++++
>>>>>    fs/ceph/dir.c        | 59 +++++++++++++++++++++-------------------=
----
>>>>>    fs/ceph/inode.c      |  7 ++++++
>>>>>    fs/ceph/mds_client.c |  2 ++
>>>>>    fs/ceph/mds_client.h |  1 +
>>>>>    5 files changed, 46 insertions(+), 31 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>>>>> index 1e08f8a64ad6..c85cb8c8bd79 100644
>>>>> --- a/fs/ceph/crypto.h
>>>>> +++ b/fs/ceph/crypto.h
>>>>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct cep=
h_fscrypt_auth *fa)
>>>>>     */
>>>>>    #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>>>>    +/*
>>>>> + * The encrypted long snap name will be in format of
>>>>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max=
 longth
>>>>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) +=
 extra 7
>>>>> + * bytes to align the total size to 8 bytes.
>>>>> + */
>>>>> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>>>>> +
>>>> I think this constant needs to be defined in a different way and we ne=
ed
>>>> to keep the snapshots names length a bit shorter than NAME_MAX.  And I=
'm
>>>> not talking just about the encrypted snapshots.
>>>>
>>>> Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
>>>> snapshot names smaller than 80 characters.  With this limitation we wo=
uld
>>>> need to keep the snapshot names < 64:
>>>>
>>>>      '_' + <name> + '_' + '<inode#>' '\0'
>>>>       1  +   64   +  1  +    12     +  1 =3D 80
>>>>
>>>> Note however that currently clients *do* allow to create snapshots with
>>>> bigger names.  And if we do that we'll get an error when doing an LSSN=
AP
>>>> on a .snap subdirectory that will contain the corresponding long name:
>>>>
>>>>     # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasd=
fgzxcvb78912345
>>>>     # ls -li a/b/.snap
>>>>     ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdf=
gzxcvb78912345_109951162777: No such file or directory
>>>>
>>>> We can limit the snapshot names on creation, but this should probably =
be
>>>> handled on the MDS side (so that old clients won't break anything).  D=
oes
>>>> this make sense?  I can work on an MDS patch for this but... to which
>>>> length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
>>>> should we take base64-encoded names already into account?
>>>>
>>>> (Sorry, I'm jumping around between PRs and patches, and trying to make=
 any
>>>> sense out of the snapshots code :-/ )
>>> For fscrypt case I think it's okay, because the max len of the encrypte=
d name
>>> will be 189 bytes, so even plusing the extra 2 * sizeof('_') - sizeof(<=
inode#>)
>>> =3D=3D 15 bytes with ceph PR#41592 it should work well.
>> Is it really 189 bytes, or 252, which is the result of base64 encoding 1=
89
>> bytes?
>
> Yeah, you are right, I misread that. The 252 is from 189 * 4 / 3, which w=
ill be
> the base64 encoded name.
>
> So, I think you should fix this to make the totally of base64 encode name=
 won't
> bigger than 240 =3D 255 - 15. So the CEPH_NOHASH_NAME_MAX should be:
>
> #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
>
> ?

That could be done, but maybe it's not worth it if the MDS returns -EINVAL
when creating a snapshot with a name that breaks this rule.  Thus, we can
still have regular file with 189 bytes names and only the snapshots will
have this extra limitation.  (I've already created PR#45312 for this.)

But I'm OK either way.

Cheers,
--=20
Lu=C3=ADs

>
>>   Reading the documentation in the CEPH_NOHASH_NAME_MAX definition
>> it seems to be 252.  And in that case we need to limit the names length
>> even further.
>>
>>> But for none fscrypt case, we must limit the max len to NAME_MAX - 2 *
>>> sizeof('_') - sizeof(<inode#>) =3D=3D 255 - 2 - 13 =3D=3D 240. So fixin=
g this in
>>> MDS side makes sense IMO.
>> Yeah, I suppose this makes sense.  I can send out a PR soon with this, a=
nd
>> try to document it somewhere.  But it may make sense to merge both PRs at
>> the same time and *backport* them to older releases.
>
> Yeah, make sense.
>
> - Xiubo
>
>> Cheers,
>
