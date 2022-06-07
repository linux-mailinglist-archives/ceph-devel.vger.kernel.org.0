Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E0F5403A1
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 18:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344958AbiFGQUX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 12:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344866AbiFGQUF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 12:20:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834AF100516;
        Tue,  7 Jun 2022 09:20:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 39D9B21BE5;
        Tue,  7 Jun 2022 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654618803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJU6PMlGS0wO7kgQB07BLWLliyeyV2R7JwwB4lP+pmo=;
        b=qi/aLs8cvfJGoRGNo4TGkrYR8dTUGv4b1y5bLfvQzm7KmRPp1HQm36/QsbZ3EjD/tp/jhy
        QQseKSOq1g0KdB1n/9DvJA355SEZ1Et9AMDCBRwYNPw6KTETmY1GS66JcVkXDtTWTzUqkR
        Gh/gnEzYuDVV8hzkfW2FGQrqJo/q5v4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654618803;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJU6PMlGS0wO7kgQB07BLWLliyeyV2R7JwwB4lP+pmo=;
        b=XjSjybSIK3XUwp5qBPcAqhuZOQmx9/zkgZSL/iZEGxxg5BD5le/PxNp+HJ//2ttEix3PwM
        xy1S41AkKerNnKCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D991113638;
        Tue,  7 Jun 2022 16:20:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G2biMbJ6n2IUdwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 16:20:02 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 2f8ed7e4;
        Tue, 7 Jun 2022 16:20:44 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max
 xattr size
References: <20220607151513.26347-1-lhenriques@suse.de>
        <20220607151513.26347-3-lhenriques@suse.de>
        <Yp9vu5RIxMc+Gbgs@magnolia>
Date:   Tue, 07 Jun 2022 17:20:44 +0100
In-Reply-To: <Yp9vu5RIxMc+Gbgs@magnolia> (Darrick J. Wong's message of "Tue, 7
        Jun 2022 08:33:15 -0700")
Message-ID: <87wnds8mxv.fsf@brahms.olymp>
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

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Tue, Jun 07, 2022 at 04:15:13PM +0100, Lu=C3=ADs Henriques wrote:
>> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
>> size for the full set of an inode's xattrs names+values, which by default
>> is 64K but it can be changed by a cluster admin.
>>=20
>> Test generic/486 started to fail after fixing a ceph bug where this limit
>> wasn't being imposed.  Adjust dynamically the size of the xattr being set
>> if the error returned is -ENOSPC.
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  src/attr_replace_test.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
>> index cca8dcf8ff60..de18e643f469 100644
>> --- a/src/attr_replace_test.c
>> +++ b/src/attr_replace_test.c
>> @@ -62,7 +62,10 @@ int main(int argc, char *argv[])
>>=20=20
>>  	/* Then, replace it with bigger one, forcing short form to leaf conver=
sion. */
>>  	memset(value, '1', size);
>> -	ret =3D fsetxattr(fd, name, value, size, XATTR_REPLACE);
>> +	do {
>> +		ret =3D fsetxattr(fd, name, value, size, XATTR_REPLACE);
>> +		size -=3D 256;
>> +	} while ((ret < 0) && (errno =3D=3D ENOSPC) && (size > 0));
>
> Isn't @size a size_t?  Which means that it can't be less than zero?  I
> wouldn't count on st_blksize (or XATTR_SIZE_MAX) always being a multiple
> of 256.

*sigh*

You're right, of course.  Do you think it would be acceptable to do this
instead:

	} while ((ret < 0) && (errno =3D=3D ENOSPC) && (size > 256));

It's still a magic number, but it should do the trick.  Although it's
still a bit ugly, I know.  My initial idea was to add an arg to this
program that would be then used as the value for 'size'; this way I could
add a ceph-specific value.  But not sure that's less ugly...

Cheers,
--=20
Lu=C3=ADs

>
> --D
>
>>  	if (ret < 0) die();
>>  	close(fd);
>>=20=20
