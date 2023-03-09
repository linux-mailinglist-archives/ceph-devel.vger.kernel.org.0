Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEFC6B20BB
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 10:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCIJzQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Mar 2023 04:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCIJzO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Mar 2023 04:55:14 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D07F751
        for <ceph-devel@vger.kernel.org>; Thu,  9 Mar 2023 01:55:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5327A21B03;
        Thu,  9 Mar 2023 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678355712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R1Aw6Yn/0Mn8Jpp5WvcrB7kzvbjPIfZDcUFVQCmn2Jk=;
        b=e7T1xCIa4gL9Jn1fjouwW8Fk9GMKYKvA3tpfunyCcQORoG6JJa51kHwdpY5O1l1WnzJ7Dy
        T2UImXiOqRQW0Jskhh+XGMwytTq19uiQ1+UxwLLVIOTG0W7GYByxwt+mLaZv32YyvMhuJx
        69BXYQxLWtDsDaquEl1xJ7M3HQ9OYcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678355712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R1Aw6Yn/0Mn8Jpp5WvcrB7kzvbjPIfZDcUFVQCmn2Jk=;
        b=jl/S3KHduSLWgClKxqTqe43gwxfELX1Ny/0mXunVJK+59xjC+CUlX6emHdTXB8knjzHY6I
        Th/U1/w/9e+qNfBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DAD9613A10;
        Thu,  9 Mar 2023 09:55:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7I1qMv+sCWSkHAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Mar 2023 09:55:11 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 9c2839e1;
        Thu, 9 Mar 2023 09:55:11 +0000 (UTC)
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
        <87fsaf88sc.fsf@suse.de>
        <d2eedcdc-9019-2004-acd9-7bdbc953488f@redhat.com>
Date:   Thu, 09 Mar 2023 09:55:11 +0000
In-Reply-To: <d2eedcdc-9019-2004-acd9-7bdbc953488f@redhat.com> (Xiubo Li's
        message of "Thu, 9 Mar 2023 15:06:29 +0800")
Message-ID: <87o7p26ygw.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 09/03/2023 01:14, Lu=C3=ADs Henriques wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>>> On 08/03/2023 17:29, Lu=C3=ADs Henriques wrote:
>>>> Xiubo Li <xiubli@redhat.com> writes:
>>>>
>>>>> On 08/03/2023 02:53, Lu=C3=ADs Henriques wrote:
>>>>>> xiubli@redhat.com writes:
>>>>>>
>>>>>>> From: Jeff Layton <jlayton@kernel.org>
>>>>>>>
>>>>>>> If we have a dentry which represents a no-key name, then we need to=
 test
>>>>>>> whether the parent directory's encryption key has since been added.=
  Do
>>>>>>> that before we test anything else about the dentry.
>>>>>>>
>>>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>>> ---
>>>>>>>     fs/ceph/dir.c | 8 ++++++--
>>>>>>>     1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>>>> index d3c2853bb0f1..5ead9f59e693 100644
>>>>>>> --- a/fs/ceph/dir.c
>>>>>>> +++ b/fs/ceph/dir.c
>>>>>>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *=
dentry, unsigned int flags)
>>>>>>>     	struct inode *dir, *inode;
>>>>>>>     	struct ceph_mds_client *mdsc;
>>>>>>>     +	valid =3D fscrypt_d_revalidate(dentry, flags);
>>>>>>> +	if (valid <=3D 0)
>>>>>>> +		return valid;
>>>>>>> +
>>>>>> This patch has confused me in the past, and today I found myself
>>>>>> scratching my head again looking at it.
>>>>>>
>>>>>> So, I've started seeing generic/123 test failing when running it with
>>>>>> test_dummy_encryption.  I was almost sure that this test used to run=
 fine
>>>>>> before, but I couldn't find any evidence (somehow I lost my old test=
ing
>>>>>> logs...).
>>>>>>
>>>>>> Anyway, the test is quite simple:
>>>>>>
>>>>>> 1. Creates a directory with write permissions for root only
>>>>>> 2. Writes into a file in that directory
>>>>>> 3. Uses 'su' to try to modify that file as a different user, and
>>>>>>       gets -EPERM
>>>>>>
>>>>>> All these steps run fine, and the test should pass.  *However*, in t=
he
>>>>>> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTE=
MPTY.
>>>>>> 'strace' shows that calling unlinkat() to remove the file got a '-EN=
OENT'
>>>>>> and then -ENOTEMPTY for the directory.
>>>>>>
>>>>>> Some digging allowed me to figure out that running commands with 'su=
' will
>>>>>> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this=
 is
>>>>>> how I ended up looking at this patch.  fscrypt_d_revalidate() will r=
eturn
>>>>>> '0' if the parent directory does has a key (fscrypt_has_encryption_k=
ey()).
>>>>>> Can we really say here that the dentry is *not* valid in that case? =
 Or
>>>>>> should that '<=3D 0' be a '< 0'?
>>>>>>
>>>>>> (But again, this patch has confused me before...)
>>>>> Luis,
>>>>>
>>>>> Could you reproduce it with the latest testing branch ?
>>>> Yes, I'm seeing this with the latest code.
>>> Okay. That's odd.
>>>
>>> BTW, are you using the non-root user to run the test ?
>>>
>>> Locally I am using the root user and still couldn't reproduce it.
>> Yes, I'm running the tests as root but I've also 'fsgqa' user in the
>> system (which is used by this test.  Anyway, for reference, here's what
>> I'm using in my fstests configuration:
>>
>> TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3D=
crc,test_dummy_encryption"
>> MOUNT_OPTIONS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3Dcrc,t=
est_dummy_encryption"
>>
>>>>> I never seen the generic/123 failure yet. And just now I ran the test=
 for many
>>>>> times locally it worked fine.
>>>> That's odd.  With 'test_dummy_encryption' mount option I can reproduce=
 it
>>>> every time.
>>>>
>>>>>   From the generic/123 test code it will never touch the key while te=
sting, that
>>>>> means the dentries under the test dir will always have the keyed name=
. And then
>>>>> the 'fscrypt_d_revalidate()' should return 1 always.
>>>>>
>>>>> Only when we remove the key will it trigger evicting the inodes and t=
hen when we
>>>>> add the key back will the 'fscrypt_d_revalidate()' return 0 by checki=
ng the
>>>>> 'fscrypt_has_encryption_key()'.
>>>>>
>>>>> As I remembered we have one or more fixes about this those days, not =
sure
>>>>> whether you were hitting those bugs we have already fixed ?
>>>> Yeah, I remember now, and I guess there's yet another one here!
>>>>
>>>> I'll look closer into this and see if I can find out something else.  =
I'm
>>>> definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably the
>>>> bug is in the error paths, when the 'fsgqa' user tries to write into t=
he
>>>> file.
>>> Please add some debug logs in the code.
>> I *think* I've something.  The problem seems to be that, after the
>> drop_caches, the test directory is evicted and ceph_evict_inode() will
>> call fscrypt_put_encryption_info().  This last function will clear the
>> inode fscrypt info.  Later on, when the test tries to write to the file
>> with:
>>
>>    _user_do "echo goo >> $my_test_subdir/data_coherency.txt"
>>
>> function ceph_atomic_open() will correctly identify that '$my_test_subdi=
r'
>> is encrypted, but the key isn't set because the inode was evicted.  This
>> means that fscrypt_has_encryption_key() will return '0' and DCACHE_NOKEY=
_NAME
>> will be *incorrectly* added to the 'data_coherency.txt' dentry flags.
>>
>> Later on, ceph_d_revalidate() will see the problem I initially described.
>>
>> The (RFC) patch bellow seems to fix the issue.  Basically, it will force
>> the fscrypt info to be set in the directory by calling __fscrypt_prepare=
_readdir()
>> and the fscrypt_has_encryption_key() will then return 'true'.
>
> Interesting.
>
> It's worth to add one separated commit to fix this.
>
> Luis, could you send one patch to the mail list ? And please add the deta=
il
> comments in the code to explain it.
>
> This will help us to under stand the code and to debug potential similar =
bugs in
> future.

Sure, I'll do that.  In fact, I'll probably send out two patches as Jeff
also suggested a better name for __fscrypt_prepare_readdir().  Not sure
Eric will take it, but it's worth trying.

Cheers,
--=20
Lu=C3=ADs
