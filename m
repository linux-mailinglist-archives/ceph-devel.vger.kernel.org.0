Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBBE6B1010
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 18:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCHRQ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 12:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCHRQb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 12:16:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169DBCC32B
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 09:15:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8892A1F38A;
        Wed,  8 Mar 2023 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678295689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeE76sivSP+XdQP32hDNR5MfI5ICV4ir/e10XIXj6o4=;
        b=CxVnbKR3e4Mgm/nnKzNeom2JlGKLiBibhNeaVbcAJLqHQQbQQEj46fuZT+1iF+urU3qlRc
        wWMLOAisUrfiAFFUym3Mg2MEnAroM9ApV/dNSlXPKwbxMK4Mavxmwo9vEZ8z+j12coXNV/
        7jMpeZfVkXaEbmdHhc0P9+bbiPnN+qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678295689;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeE76sivSP+XdQP32hDNR5MfI5ICV4ir/e10XIXj6o4=;
        b=VRh+U0glTIToD6fy8PhWMFAKzWAAVUeHsYPotTosII3ExcI+X7LLAPpJtniJ40EGqkR1aQ
        IhQIMupgOt3CSpBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 226B71348D;
        Wed,  8 Mar 2023 17:14:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IscqBYnCCGRtTQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 08 Mar 2023 17:14:49 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 14d68bdd;
        Wed, 8 Mar 2023 17:14:43 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
References: <20230227032813.337906-1-xiubli@redhat.com>
        <20230227032813.337906-26-xiubli@redhat.com> <87o7p48kby.fsf@suse.de>
        <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com>
        <87jzzr8ubv.fsf@suse.de>
        <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com>
Date:   Wed, 08 Mar 2023 17:14:43 +0000
In-Reply-To: <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com> (Xiubo Li's
        message of "Wed, 8 Mar 2023 18:42:47 +0800")
Message-ID: <87fsaf88sc.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 08/03/2023 17:29, Lu=C3=ADs Henriques wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>>> On 08/03/2023 02:53, Lu=C3=ADs Henriques wrote:
>>>> xiubli@redhat.com writes:
>>>>
>>>>> From: Jeff Layton <jlayton@kernel.org>
>>>>>
>>>>> If we have a dentry which represents a no-key name, then we need to t=
est
>>>>> whether the parent directory's encryption key has since been added.  =
Do
>>>>> that before we test anything else about the dentry.
>>>>>
>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>    fs/ceph/dir.c | 8 ++++++--
>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>> index d3c2853bb0f1..5ead9f59e693 100644
>>>>> --- a/fs/ceph/dir.c
>>>>> +++ b/fs/ceph/dir.c
>>>>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *de=
ntry, unsigned int flags)
>>>>>    	struct inode *dir, *inode;
>>>>>    	struct ceph_mds_client *mdsc;
>>>>>    +	valid =3D fscrypt_d_revalidate(dentry, flags);
>>>>> +	if (valid <=3D 0)
>>>>> +		return valid;
>>>>> +
>>>> This patch has confused me in the past, and today I found myself
>>>> scratching my head again looking at it.
>>>>
>>>> So, I've started seeing generic/123 test failing when running it with
>>>> test_dummy_encryption.  I was almost sure that this test used to run f=
ine
>>>> before, but I couldn't find any evidence (somehow I lost my old testing
>>>> logs...).
>>>>
>>>> Anyway, the test is quite simple:
>>>>
>>>> 1. Creates a directory with write permissions for root only
>>>> 2. Writes into a file in that directory
>>>> 3. Uses 'su' to try to modify that file as a different user, and
>>>>      gets -EPERM
>>>>
>>>> All these steps run fine, and the test should pass.  *However*, in the
>>>> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMP=
TY.
>>>> 'strace' shows that calling unlinkat() to remove the file got a '-ENOE=
NT'
>>>> and then -ENOTEMPTY for the directory.
>>>>
>>>> Some digging allowed me to figure out that running commands with 'su' =
will
>>>> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
>>>> how I ended up looking at this patch.  fscrypt_d_revalidate() will ret=
urn
>>>> '0' if the parent directory does has a key (fscrypt_has_encryption_key=
()).
>>>> Can we really say here that the dentry is *not* valid in that case?  Or
>>>> should that '<=3D 0' be a '< 0'?
>>>>
>>>> (But again, this patch has confused me before...)
>>> Luis,
>>>
>>> Could you reproduce it with the latest testing branch ?
>> Yes, I'm seeing this with the latest code.
>
> Okay. That's odd.
>
> BTW, are you using the non-root user to run the test ?
>
> Locally I am using the root user and still couldn't reproduce it.

Yes, I'm running the tests as root but I've also 'fsgqa' user in the
system (which is used by this test.  Anyway, for reference, here's what
I'm using in my fstests configuration:

TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3Dcrc=
,test_dummy_encryption"
MOUNT_OPTIONS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3Dcrc,test=
_dummy_encryption"

>>
>>> I never seen the generic/123 failure yet. And just now I ran the test f=
or many
>>> times locally it worked fine.
>> That's odd.  With 'test_dummy_encryption' mount option I can reproduce it
>> every time.
>>
>>>  From the generic/123 test code it will never touch the key while testi=
ng, that
>>> means the dentries under the test dir will always have the keyed name. =
And then
>>> the 'fscrypt_d_revalidate()' should return 1 always.
>>>
>>> Only when we remove the key will it trigger evicting the inodes and the=
n when we
>>> add the key back will the 'fscrypt_d_revalidate()' return 0 by checking=
 the
>>> 'fscrypt_has_encryption_key()'.
>>>
>>> As I remembered we have one or more fixes about this those days, not su=
re
>>> whether you were hitting those bugs we have already fixed ?
>> Yeah, I remember now, and I guess there's yet another one here!
>>
>> I'll look closer into this and see if I can find out something else.  I'm
>> definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably the
>> bug is in the error paths, when the 'fsgqa' user tries to write into the
>> file.
>
> Please add some debug logs in the code.

I *think* I've something.  The problem seems to be that, after the
drop_caches, the test directory is evicted and ceph_evict_inode() will
call fscrypt_put_encryption_info().  This last function will clear the
inode fscrypt info.  Later on, when the test tries to write to the file
with:

  _user_do "echo goo >> $my_test_subdir/data_coherency.txt"

function ceph_atomic_open() will correctly identify that '$my_test_subdir'
is encrypted, but the key isn't set because the inode was evicted.  This
means that fscrypt_has_encryption_key() will return '0' and DCACHE_NOKEY_NA=
ME
will be *incorrectly* added to the 'data_coherency.txt' dentry flags.

Later on, ceph_d_revalidate() will see the problem I initially described.

The (RFC) patch bellow seems to fix the issue.  Basically, it will force
the fscrypt info to be set in the directory by calling __fscrypt_prepare_re=
addir()
and the fscrypt_has_encryption_key() will then return 'true'.

Cheers
--=20
Lu=C3=ADs

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index dee3b445f415..3f2df84a6323 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -795,7 +795,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *=
dentry,
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-		if (!fscrypt_has_encryption_key(dir)) {
+		err =3D __fscrypt_prepare_readdir(dir);
+		if (err || (!err && !fscrypt_has_encryption_key(dir))) {
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
 			spin_unlock(&dentry->d_lock);
