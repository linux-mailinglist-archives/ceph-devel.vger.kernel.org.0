Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4B454671C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 15:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245550AbiFJNIV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 09:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345684AbiFJNIS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 09:08:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670757B1A;
        Fri, 10 Jun 2022 06:08:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 416081F925;
        Fri, 10 Jun 2022 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654866494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pN15EzvHvDxnJvn/+qlg0Yy8tgRRT422xFmVcwmKho=;
        b=dmQcX6Lcqfeh66gX6zxFgHo8aSS8N++OptPI1+/UrbRKJuevlnAl4pdNzeu46kyHQ7QAm8
        zLIWVy8EQ8VYND98l3JKWJHG3qOHw4pJQR7BSu4TMEHCuuKjBKYKvuQ3S9jvBmsqOiBbBv
        UL2iqLFwTk87Ui1EFNbYttJr5Lq7Jlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654866494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pN15EzvHvDxnJvn/+qlg0Yy8tgRRT422xFmVcwmKho=;
        b=MMgcirB6XNuztHld7hoA3J98SKAUwL3RTi1TNpHb931GxpUkFGsuo42+WYdTThNSwyB+eJ
        q+JnxhELbhdZt0Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB74113941;
        Fri, 10 Jun 2022 13:08:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t5nNNj1Co2LZQQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 10 Jun 2022 13:08:13 +0000
Received: from localhost (orpheu.olymp [local])
        by orpheu.olymp (OpenSMTPD) with ESMTPA id 7c611366;
        Fri, 10 Jun 2022 14:08:12 +0100 (WEST)
From:   =?utf-8?Q?Lu=C3=ADs?= Henriques <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] generic/486: adjust the max xattr size
References: <20220609105343.13591-1-lhenriques@suse.de>
        <20220609105343.13591-3-lhenriques@suse.de>
        <4c4572a2-2681-c2f7-a8dc-55eb2f5fc077@redhat.com>
        <20220610072545.GY1098723@dread.disaster.area>
        <20220610091901.is7qjqq3asr7hihh@zlang-mailbox>
Date:   Fri, 10 Jun 2022 14:08:12 +0100
In-Reply-To: <20220610091901.is7qjqq3asr7hihh@zlang-mailbox> (Zorro Lang's
        message of "Fri, 10 Jun 2022 17:19:01 +0800")
Message-ID: <87fskcu0n7.fsf@orpheu.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Zorro Lang <zlang@redhat.com> writes:

> On Fri, Jun 10, 2022 at 05:25:45PM +1000, Dave Chinner wrote:
>> On Fri, Jun 10, 2022 at 01:35:36PM +0800, Xiubo Li wrote:
>> >=20
>> > On 6/9/22 6:53 PM, Lu=C3=ADs Henriques wrote:
>> > > CephFS doesn't have a maximum xattr size.  Instead, it imposes a max=
imum
>> > > size for the full set of xattrs names+values, which by default is 64=
K.
>> > > And since ceph reports 4M as the blocksize (the default ceph object =
size),
>> > > generic/486 will fail in this filesystem because it will end up using
>> > > XATTR_SIZE_MAX to set the size of the 2nd (big) xattr value.
>> > >=20
>> > > The fix is to adjust the max size in attr_replace_test so that it ta=
kes
>> > > into account the initial xattr name and value lengths.
>> > >=20
>> > > Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> > > ---
>> > >   src/attr_replace_test.c | 7 ++++++-
>> > >   1 file changed, 6 insertions(+), 1 deletion(-)
>> > >=20
>> > > diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
>> > > index cca8dcf8ff60..1c8d1049a1d8 100644
>> > > --- a/src/attr_replace_test.c
>> > > +++ b/src/attr_replace_test.c
>> > > @@ -29,6 +29,11 @@ int main(int argc, char *argv[])
>> > >   	char *value;
>> > >   	struct stat sbuf;
>> > >   	size_t size =3D sizeof(value);
>> > > +	/*
>> > > +	 * Take into account the initial (small) xattr name and value size=
s and
>> > > +	 * subtract them from the XATTR_SIZE_MAX maximum.
>> > > +	 */
>> > > +	size_t maxsize =3D XATTR_SIZE_MAX - strlen(name) - 1;
>> >=20
>> > Why not use the statfs to get the filesystem type first ? And then just
>> > minus the strlen(name) for ceph only ?
>>=20
>> No. The test mechanism has no business knowing what filesystem type
>> it is running on - the test itself is supposed to get the limits for
>> the filesystem type from the test infrastructure.
>>=20
>> As I've already said: the right thing to do is to pass the maximum
>> attr size for the test to use via the command line from the fstest
>> itself. As per g/020, the fstests infrastructure is where we encode
>> weird fs limit differences and behaviours based on $FSTYP.  Hacking
>> around weird filesystem specific behaviours deep inside random bits
>> of test source code is not maintainable.
>>=20
>> AFAIA, only ceph is having a problem with this test, so it's trivial
>> to encode into g/486 with:
>>=20
>> # ceph has a weird dynamic maximum xattr size and block size that is
>> # much, much larger than the maximum supported attr size. Hence the
>> # replace test can't auto-probe a sane attr size and so we have
>> # to provide it with a maximum size that will work.
>> max_attr_size=3D65536
>> [ "$FSTYP" =3D "ceph" ] && max_attr_size=3D64000
>> attr_replace_test -m $max_attr_size .....
>> .....
>
> Agree. I'd recommend changing the attr_replace_test.c, make it have a
> default max xattr size (keep using the XATTR_SIZE_MAX or define one if
> it's not defined), then give it an optinal option which can specify a
> customed max xattr size from outside.
>
> Then the test case (e.g. g/486) which uses attr_replace_test can
> specify a max xattr size if it needs. And it's easier to figure
> out what attr size is better for a specified fs in test case.

Awesome, thanks.  I'll send out next rev with these changes.  Thank you
all.

Cheers,
--=20
Lu=C3=ADs
