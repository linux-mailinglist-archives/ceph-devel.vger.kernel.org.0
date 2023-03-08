Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1046B1210
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 20:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCHTce (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 14:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCHTcd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 14:32:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EF7C080C
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 11:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3256FB81269
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 19:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A88BC433EF;
        Wed,  8 Mar 2023 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678303941;
        bh=uaVfhh1+HAYIJrWroLMZa3r36NnDV4NsepfdiIKhh1k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k02s5SK0u4vyb73uvXFL9lz4QzNqXov2V+Bo5MQSO48gnjD/KwnMRYI4CYWbzgB7j
         F7k3+Lbh3zVBEqHbnsjtxslAQjKMC3zu9I4+Z1Olag2SWzD+EO76fU3dKFEIdzQJpx
         pxsRKpVoenOm7+RLanH/kBWJRTuSWjrIAmTZ5Y9Pwscd2fJf7sGS/8TRT7S3ZFjIZE
         Jdz+Obu7oKj66EyFQc0DVkj7moVeBQZZindcJ0z1ig+H09e1NYTcSYwJtLwdDyLXcs
         OvlMRN8S7vs673oa2HQKLPIMGimSpGxLyAWuxZWQ6bc8RmMyDUbUCdNuIHxva5ShXI
         JRWHea6VQCdHQ==
Message-ID: <04053d75104815f252b0239aa714990a05c1dafc.camel@kernel.org>
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, vshankar@redhat.com,
        mchangir@redhat.com
Date:   Wed, 08 Mar 2023 14:32:19 -0500
In-Reply-To: <871qlz859a.fsf@suse.de>
References: <20230227032813.337906-1-xiubli@redhat.com>
         <20230227032813.337906-26-xiubli@redhat.com> <87o7p48kby.fsf@suse.de>
         <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com> <87jzzr8ubv.fsf@suse.de>
         <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com> <87fsaf88sc.fsf@suse.de>
         <406dc339c219d98639b752342136461f5070f259.camel@kernel.org>
         <871qlz859a.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2023-03-08 at 18:30 +0000, Lu=EDs Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>=20
> > On Wed, 2023-03-08 at 17:14 +0000, Lu=EDs Henriques wrote:
> > > Xiubo Li <xiubli@redhat.com> writes:
> > >=20
> > > > On 08/03/2023 17:29, Lu=EDs Henriques wrote:
> > > > > Xiubo Li <xiubli@redhat.com> writes:
> > > > >=20
> > > > > > On 08/03/2023 02:53, Lu=EDs Henriques wrote:
> > > > > > > xiubli@redhat.com=A0writes:
> > > > > > >=20
> > > > > > > > From: Jeff Layton <jlayton@kernel.org>
> > > > > > > >=20
> > > > > > > > If we have a dentry which represents a no-key name, then we=
 need to test
> > > > > > > > whether the parent directory's encryption key has since bee=
n added.=A0 Do
> > > > > > > > that before we test anything else about the dentry.
> > > > > > > >=20
> > > > > > > > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> > > > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > > > > ---
> > > > > > > > =A0=A0=A0 fs/ceph/dir.c | 8 ++++++--
> > > > > > > > =A0=A0=A0 1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > > > >=20
> > > > > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > > > > index d3c2853bb0f1..5ead9f59e693 100644
> > > > > > > > --- a/fs/ceph/dir.c
> > > > > > > > +++ b/fs/ceph/dir.c
> > > > > > > > @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct =
dentry *dentry, unsigned int flags)
> > > > > > > > =A0=A0=A0=A0	struct inode *dir, *inode;
> > > > > > > > =A0=A0=A0=A0	struct ceph_mds_client *mdsc;
> > > > > > > > =A0=A0=A0 +	valid =3D fscrypt_d_revalidate(dentry, flags);
> > > > > > > > +	if (valid <=3D 0)
> > > > > > > > +		return valid;
> > > > > > > > +
> > > > > > > This patch has confused me in the past, and today I found mys=
elf
> > > > > > > scratching my head again looking at it.
> > > > > > >=20
> > > > > > > So, I've started seeing generic/123 test failing when running=
 it with
> > > > > > > test_dummy_encryption.=A0 I was almost sure that this test us=
ed to run fine
> > > > > > > before, but I couldn't find any evidence (somehow I lost my o=
ld testing
> > > > > > > logs...).
> > > > > > >=20
> > > > > > > Anyway, the test is quite simple:
> > > > > > >=20
> > > > > > > 1. Creates a directory with write permissions for root only
> > > > > > > 2. Writes into a file in that directory
> > > > > > > 3. Uses 'su' to try to modify that file as a different user, =
and
> > > > > > > =A0=A0=A0=A0=A0 gets -EPERM
> > > > > > >=20
> > > > > > > All these steps run fine, and the test should pass.=A0 *Howev=
er*, in the
> > > > > > > test cleanup function, a simple 'rm -rf <dir>' will fail with=
 -ENOTEMPTY.
> > > > > > > 'strace' shows that calling unlinkat() to remove the file got=
 a '-ENOENT'
> > > > > > > and then -ENOTEMPTY for the directory.
> > > > > > >=20
> > > > > > > Some digging allowed me to figure out that running commands w=
ith 'su' will
> > > > > > > drop caches (I see 'su (874): drop_caches: 2' in the log).=A0=
 And this is
> > > > > > > how I ended up looking at this patch.=A0 fscrypt_d_revalidate=
() will return
> > > > > > > '0' if the parent directory does has a key (fscrypt_has_encry=
ption_key()).
> > > > > > > Can we really say here that the dentry is *not* valid in that=
 case?=A0 Or
> > > > > > > should that '<=3D 0' be a '< 0'?
> > > > > > >=20
> > > > > > > (But again, this patch has confused me before...)
> > > > > > Luis,
> > > > > >=20
> > > > > > Could you reproduce it with the latest testing branch ?
> > > > > Yes, I'm seeing this with the latest code.
> > > >=20
> > > > Okay. That's odd.
> > > >=20
> > > > BTW, are you using the non-root user to run the test ?
> > > >=20
> > > > Locally I am using the root user and still couldn't reproduce it.
> > >=20
> > > Yes, I'm running the tests as root but I've also 'fsgqa' user in the
> > > system (which is used by this test.=A0 Anyway, for reference, here's =
what
> > > I'm using in my fstests configuration:
> > >=20
> > > TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=
=3Dcrc,test_dummy_encryption"
> > > MOUNT_OPTIONS=3D"-o name=3Dadmin,secret=3D<key>,copyfrom,ms_mode=3Dcr=
c,test_dummy_encryption"
> > >=20
> > > > >=20
> > > > > > I never seen the generic/123 failure yet. And just now I ran th=
e test for many
> > > > > > times locally it worked fine.
> > > > > That's odd.=A0 With 'test_dummy_encryption' mount option I can re=
produce it
> > > > > every time.
> > > > >=20
> > > > > > =A0 From the generic/123 test code it will never touch the key =
while testing, that
> > > > > > means the dentries under the test dir will always have the keye=
d name. And then
> > > > > > the 'fscrypt_d_revalidate()' should return 1 always.
> > > > > >=20
> > > > > > Only when we remove the key will it trigger evicting the inodes=
 and then when we
> > > > > > add the key back will the 'fscrypt_d_revalidate()' return 0 by =
checking the
> > > > > > 'fscrypt_has_encryption_key()'.
> > > > > >=20
> > > > > > As I remembered we have one or more fixes about this those days=
, not sure
> > > > > > whether you were hitting those bugs we have already fixed ?
> > > > > Yeah, I remember now, and I guess there's yet another one here!
> > > > >=20
> > > > > I'll look closer into this and see if I can find out something el=
se.=A0 I'm
> > > > > definitely seeing 'fscrypt_d_revalidate()' returning 0, so probab=
ly the
> > > > > bug is in the error paths, when the 'fsgqa' user tries to write i=
nto the
> > > > > file.
> > > >=20
> > > > Please add some debug logs in the code.
> > >=20
> > > I *think* I've something.=A0 The problem seems to be that, after the
> > > drop_caches, the test directory is evicted and ceph_evict_inode() wil=
l
> > > call fscrypt_put_encryption_info().=A0 This last function will clear =
the
> > > inode fscrypt info.=A0 Later on, when the test tries to write to the =
file
> > > with:
> > >=20
> > > =A0 _user_do "echo goo >> $my_test_subdir/data_coherency.txt"
> > >=20
> > > function ceph_atomic_open() will correctly identify that '$my_test_su=
bdir'
> > > is encrypted, but the key isn't set because the inode was evicted.=A0=
 This
> > > means that fscrypt_has_encryption_key() will return '0' and DCACHE_NO=
KEY_NAME
> > > will be *incorrectly* added to the 'data_coherency.txt' dentry flags.
> > >=20
> > > Later on, ceph_d_revalidate() will see the problem I initially descri=
bed.
> > >=20
> > > The (RFC) patch bellow seems to fix the issue.=A0 Basically, it will =
force
> > > the fscrypt info to be set in the directory by calling __fscrypt_prep=
are_readdir()
> > > and the fscrypt_has_encryption_key() will then return 'true'.
> > >=20
> >=20
> >=20
> > > Cheers
> > > --
> > > Lu=EDs
> > >=20
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index dee3b445f415..3f2df84a6323 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -795,7 +795,8 @@ int ceph_atomic_open(struct inode *dir, struct de=
ntry *dentry,
> > > =A0	ihold(dir);
> > > =A0	if (IS_ENCRYPTED(dir)) {
> > > =A0		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> > > -		if (!fscrypt_has_encryption_key(dir)) {
> > > +		err =3D __fscrypt_prepare_readdir(dir);
> >=20
> > I want to say that i had something like this in place during an earlier
> > version of this series, but for different reasons. I think I convinced
> > myself later though that it wasn't needed? Oh well...
>=20
> Ah, good to know it _may_ make sense :-)
>=20
> > > +		if (err || (!err && !fscrypt_has_encryption_key(dir))) {
> > > =A0			spin_lock(&dentry->d_lock);
> > > =A0			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> > > =A0			spin_unlock(&dentry->d_lock);
> >=20
> > Once an inode is evicted, my understanding was that it won't end up
> > being used anymore. It's on its way out of the cache and it's not hashe=
d
> > anymore at that point.
> >=20
> > How does a new atomic open after drop_caches end up with the inode
> > struct that existed before it?
>=20
> Hmm... so, I *think* that what's happening is that it is a new inode but
> the key is still available.  Looking at the code it seems that fscrypt
> will get the context (->get_context()) from ceph code and then
> fscrypt_setup_encryption_info() should initialize everything in the
> inode.  And at that point fscrypt_has_encryption_key() will finally retur=
n
> 'true'.
>=20
> Does this make sense?
>=20

Yeah, I think so. This is also coming back to me a bit too...

Basically none of the existing fscrypt-supporting filesystems deal with
atomic_open, so we need to do *something* in this codepath to ensure
that the key is available if the parent is encrypted. The regular open
path, we call fscrypt_file_open to ensure that, but we don't have the
inode for the thing yet at this point.

__fscrypt_preapre_readdir is what we need here (though that really needs
a new name since it's not just for readdir).

Reviewed-by: Jeff Layton <jlayton@kernel.org>
