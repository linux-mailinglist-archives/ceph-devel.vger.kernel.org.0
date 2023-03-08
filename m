Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1405F6B1107
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 19:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCHSbH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 13:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjCHSbG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 13:31:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69172BF8E5
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 10:31:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 804B021A70;
        Wed,  8 Mar 2023 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678300258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvyJCM/71V4ybCjJ8M7ns6FHmy1TSwiL6NAbAP2+bUA=;
        b=by+a7AdoW353k3EErmjrKorNp1vIoqXBps10u08+WbbGZxqpkkrR7jkExIV3KSzIGT39td
        WkGrZ9NJYjd0z7eD8eagq5F3tHFRvM07e+eyqmz8I06PjoJ/ayhbsPAzQY+nhOLZ1W3Ni9
        T/xqzu8KlPlxNEQWcpeuZHhVmGEqVtQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678300258;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvyJCM/71V4ybCjJ8M7ns6FHmy1TSwiL6NAbAP2+bUA=;
        b=g4kvMT+k352pXBX9upmT3IJLw1XuP0ISLk5mq/dCcknhdAm1C2HoKonBTXem+gAJMghAbC
        T3dLEuvEsaFv2JAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D9301391B;
        Wed,  8 Mar 2023 18:30:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EPQIBGLUCGTpdAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 08 Mar 2023 18:30:58 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 47827059;
        Wed, 8 Mar 2023 18:30:57 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, vshankar@redhat.com,
        mchangir@redhat.com
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
References: <20230227032813.337906-1-xiubli@redhat.com>
        <20230227032813.337906-26-xiubli@redhat.com> <87o7p48kby.fsf@suse.de>
        <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com>
        <87jzzr8ubv.fsf@suse.de>
        <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com>
        <87fsaf88sc.fsf@suse.de>
        <406dc339c219d98639b752342136461f5070f259.camel@kernel.org>
Date:   Wed, 08 Mar 2023 18:30:57 +0000
In-Reply-To: <406dc339c219d98639b752342136461f5070f259.camel@kernel.org> (Jeff
        Layton's message of "Wed, 08 Mar 2023 12:54:43 -0500")
Message-ID: <871qlz859a.fsf@suse.de>
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

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2023-03-08 at 17:14 +0000, Lu=C3=ADs Henriques wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>=20
>> > On 08/03/2023 17:29, Lu=C3=ADs Henriques wrote:
>> > > Xiubo Li <xiubli@redhat.com> writes:
>> > >=20
>> > > > On 08/03/2023 02:53, Lu=C3=ADs Henriques wrote:
>> > > > > xiubli@redhat.com=C2=A0writes:
>> > > > >=20
>> > > > > > From: Jeff Layton <jlayton@kernel.org>
>> > > > > >=20
>> > > > > > If we have a dentry which represents a no-key name, then we ne=
ed to test
>> > > > > > whether the parent directory's encryption key has since been a=
dded.=C2=A0 Do
>> > > > > > that before we test anything else about the dentry.
>> > > > > >=20
>> > > > > > Reviewed-by: Xiubo Li <xiubli@redhat.com>
>> > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > > > > > ---
>> > > > > > =C2=A0=C2=A0=C2=A0 fs/ceph/dir.c | 8 ++++++--
>> > > > > > =C2=A0=C2=A0=C2=A0 1 file changed, 6 insertions(+), 2 deletion=
s(-)
>> > > > > >=20
>> > > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> > > > > > index d3c2853bb0f1..5ead9f59e693 100644
>> > > > > > --- a/fs/ceph/dir.c
>> > > > > > +++ b/fs/ceph/dir.c
>> > > > > > @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct den=
try *dentry, unsigned int flags)
>> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0	struct inode *dir, *inode;
>> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0	struct ceph_mds_client *mdsc;
>> > > > > > =C2=A0=C2=A0=C2=A0 +	valid =3D fscrypt_d_revalidate(dentry, fl=
ags);
>> > > > > > +	if (valid <=3D 0)
>> > > > > > +		return valid;
>> > > > > > +
>> > > > > This patch has confused me in the past, and today I found myself
>> > > > > scratching my head again looking at it.
>> > > > >=20
>> > > > > So, I've started seeing generic/123 test failing when running it=
 with
>> > > > > test_dummy_encryption.=C2=A0 I was almost sure that this test us=
ed to run fine
>> > > > > before, but I couldn't find any evidence (somehow I lost my old =
testing
>> > > > > logs...).
>> > > > >=20
>> > > > > Anyway, the test is quite simple:
>> > > > >=20
>> > > > > 1. Creates a directory with write permissions for root only
>> > > > > 2. Writes into a file in that directory
>> > > > > 3. Uses 'su' to try to modify that file as a different user, and
>> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gets -EPERM
>> > > > >=20
>> > > > > All these steps run fine, and the test should pass.=C2=A0 *Howev=
er*, in the
>> > > > > test cleanup function, a simple 'rm -rf <dir>' will fail with -E=
NOTEMPTY.
>> > > > > 'strace' shows that calling unlinkat() to remove the file got a =
'-ENOENT'
>> > > > > and then -ENOTEMPTY for the directory.
>> > > > >=20
>> > > > > Some digging allowed me to figure out that running commands with=
 'su' will
>> > > > > drop caches (I see 'su (874): drop_caches: 2' in the log).=C2=A0=
 And this is
>> > > > > how I ended up looking at this patch.=C2=A0 fscrypt_d_revalidate=
() will return
>> > > > > '0' if the parent directory does has a key (fscrypt_has_encrypti=
on_key()).
>> > > > > Can we really say here that the dentry is *not* valid in that ca=
se?=C2=A0 Or
>> > > > > should that '<=3D 0' be a '< 0'?
>> > > > >=20
>> > > > > (But again, this patch has confused me before...)
>> > > > Luis,
>> > > >=20
>> > > > Could you reproduce it with the latest testing branch ?
>> > > Yes, I'm seeing this with the latest code.
>> >=20
>> > Okay. That's odd.
>> >=20
>> > BTW, are you using the non-root user to run the test ?
>> >=20
>> > Locally I am using the root user and still couldn't reproduce it.
>>=20
>> Yes, I'm running the tests as root but I've also 'fsgqa' user in the
>> system (which is used by this test.=C2=A0 Anyway, for reference, here's =
what
>> I'm using in my fstests configuration:
>>=20
>> TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3D=
crc,test_dummy_encryption"
>> MOUNT_OPTIONS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3Dcrc,t=
est_dummy_encryption"
>>=20
>> > >=20
>> > > > I never seen the generic/123 failure yet. And just now I ran the t=
est for many
>> > > > times locally it worked fine.
>> > > That's odd.=C2=A0 With 'test_dummy_encryption' mount option I can re=
produce it
>> > > every time.
>> > >=20
>> > > > =C2=A0 From the generic/123 test code it will never touch the key =
while testing, that
>> > > > means the dentries under the test dir will always have the keyed n=
ame. And then
>> > > > the 'fscrypt_d_revalidate()' should return 1 always.
>> > > >=20
>> > > > Only when we remove the key will it trigger evicting the inodes an=
d then when we
>> > > > add the key back will the 'fscrypt_d_revalidate()' return 0 by che=
cking the
>> > > > 'fscrypt_has_encryption_key()'.
>> > > >=20
>> > > > As I remembered we have one or more fixes about this those days, n=
ot sure
>> > > > whether you were hitting those bugs we have already fixed ?
>> > > Yeah, I remember now, and I guess there's yet another one here!
>> > >=20
>> > > I'll look closer into this and see if I can find out something else.=
=C2=A0 I'm
>> > > definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably =
the
>> > > bug is in the error paths, when the 'fsgqa' user tries to write into=
 the
>> > > file.
>> >=20
>> > Please add some debug logs in the code.
>>=20
>> I *think* I've something.=C2=A0 The problem seems to be that, after the
>> drop_caches, the test directory is evicted and ceph_evict_inode() will
>> call fscrypt_put_encryption_info().=C2=A0 This last function will clear =
the
>> inode fscrypt info.=C2=A0 Later on, when the test tries to write to the =
file
>> with:
>>=20
>> =C2=A0 _user_do "echo goo >> $my_test_subdir/data_coherency.txt"
>>=20
>> function ceph_atomic_open() will correctly identify that '$my_test_subdi=
r'
>> is encrypted, but the key isn't set because the inode was evicted.=C2=A0=
 This
>> means that fscrypt_has_encryption_key() will return '0' and DCACHE_NOKEY=
_NAME
>> will be *incorrectly* added to the 'data_coherency.txt' dentry flags.
>>=20
>> Later on, ceph_d_revalidate() will see the problem I initially described.
>>=20
>> The (RFC) patch bellow seems to fix the issue.=C2=A0 Basically, it will =
force
>> the fscrypt info to be set in the directory by calling __fscrypt_prepare=
_readdir()
>> and the fscrypt_has_encryption_key() will then return 'true'.
>>=20
>
>
>> Cheers
>> --
>> Lu=C3=ADs
>>=20
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index dee3b445f415..3f2df84a6323 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -795,7 +795,8 @@ int ceph_atomic_open(struct inode *dir, struct dentr=
y *dentry,
>> =C2=A0	ihold(dir);
>> =C2=A0	if (IS_ENCRYPTED(dir)) {
>> =C2=A0		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> -		if (!fscrypt_has_encryption_key(dir)) {
>> +		err =3D __fscrypt_prepare_readdir(dir);
>
> I want to say that i had something like this in place during an earlier
> version of this series, but for different reasons. I think I convinced
> myself later though that it wasn't needed? Oh well...

Ah, good to know it _may_ make sense :-)

>> +		if (err || (!err && !fscrypt_has_encryption_key(dir))) {
>> =C2=A0			spin_lock(&dentry->d_lock);
>> =C2=A0			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> =C2=A0			spin_unlock(&dentry->d_lock);
>
> Once an inode is evicted, my understanding was that it won't end up
> being used anymore. It's on its way out of the cache and it's not hashed
> anymore at that point.
>
> How does a new atomic open after drop_caches end up with the inode
> struct that existed before it?

Hmm... so, I *think* that what's happening is that it is a new inode but
the key is still available.  Looking at the code it seems that fscrypt
will get the context (->get_context()) from ceph code and then
fscrypt_setup_encryption_info() should initialize everything in the
inode.  And at that point fscrypt_has_encryption_key() will finally return
'true'.

Does this make sense?

Cheers,
--=20
Lu=C3=ADs
