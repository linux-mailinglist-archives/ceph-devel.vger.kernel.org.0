Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007CD4F2EF7
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Apr 2022 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbiDEJQR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Apr 2022 05:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiDEI6S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Apr 2022 04:58:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F7325296;
        Tue,  5 Apr 2022 01:53:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A438E210E1;
        Tue,  5 Apr 2022 08:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649148796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86UUHR3Dy9+pdg+eufmp0f9GqyDzqScwzaQx7GBUu+0=;
        b=mRwz+qPT+zjkyPliKDP0HFTS2QTxw861gZ5WuFUvEKctTZ2UC5Xe2SPYi+xksmEPZgY0fP
        dm86974ILn/1ekE5w1NDK4eu3curAbYc0Jp3dLNXWb2yV+NqqZLR6MyyVjKxrcMAdaPifK
        HIpy2KU9/w3cCpuwC+KP57VyP3dkNbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649148796;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86UUHR3Dy9+pdg+eufmp0f9GqyDzqScwzaQx7GBUu+0=;
        b=wDFAYKoZJrHoonGQj5r3SmmmqR/srKFl2GAtmGJOjNYFQmDMIH/zwxhYJi96I08uzEo5KT
        ADyLpf9LIrFc0ABg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 54CA513A30;
        Tue,  5 Apr 2022 08:53:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LQnYEXwDTGJrHwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 05 Apr 2022 08:53:16 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 98da782f;
        Tue, 5 Apr 2022 08:53:39 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] common/encrypt: allow the use of 'fscrypt:' as key
 prefix
References: <20220404102554.6616-1-lhenriques@suse.de>
        <YkuMG5MH17qkS0EA@sol.localdomain>
Date:   Tue, 05 Apr 2022 09:53:39 +0100
In-Reply-To: <YkuMG5MH17qkS0EA@sol.localdomain> (Eric Biggers's message of
        "Mon, 4 Apr 2022 17:23:55 -0700")
Message-ID: <87wng3ap2k.fsf@brahms.olymp>
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

> The code looks fine, but the explanation needs some tweaks:
>
> On Mon, Apr 04, 2022 at 11:25:54AM +0100, Lu=C3=ADs Henriques wrote:
>> fscrypt keys have used the $FSTYP as prefix.  However this format is bei=
ng
>> deprecated -- newer kernels already allow the usage of the generic
>> 'fscrypt:' prefix for ext4 and f2fs.  This patch allows the usage of this
>> new prefix for testing filesystems that have never supported the old
>> format, but keeping the $FSTYP prefix for filesystems that support it, so
>> that old kernels can be tested.
>
> This explanation is inconsistent with the code, which uses FSTYP for only=
 ext4
> and f2fs, and fscrypt for everything else including ubifs.
>
> A better explanation would be something like "Only use $FSTYP on filesyst=
ems
> that never supported the 'fscrypt' prefix, i.e. ext4 and f2fs."
>
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
>
> The first part of this comment sort of implies that FSTYP is the default =
and
> "fscrypt" is the exception, but it should be the other way around.
>
> How about:
>
> # When fscrypt keys are added using the legacy mechanism (process-subscri=
bed
> # keyrings rather than filesystem keyrings), they are normally named
> # "fscrypt:KEYDESC" where KEYDESC is the 16-character key descriptor hex =
string.
> # However, ext4 and f2fs didn't add support for the "fscrypt" prefix until
> # kernel v4.8 and v4.6, respectively.  Before that, they used "ext4" and =
"f2fs",
> # respectively.  To allow testing ext4 and f2fs encryption on kernels old=
er than
> # this, we use these filesystem-specific prefixes for ext4 and f2fs.

Doh!  Yes, of course I need to adjust the documentation.  Sorry, I'll send
v3 shortly.  Thanks!

Cheers,
--=20
Lu=C3=ADs
