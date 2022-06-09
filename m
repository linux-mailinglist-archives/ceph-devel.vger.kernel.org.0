Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40DE544FDD
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 16:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245509AbiFIOxp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 10:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245282AbiFIOxg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 10:53:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE6A2332D3;
        Thu,  9 Jun 2022 07:53:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4A8C021FA2;
        Thu,  9 Jun 2022 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654786414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3aO+2GrWqukkSEEG3uFZkKnaxnzcC/J8dSBs7I2GU8=;
        b=TB2xbvNdxJLSM8eFDhIFGaq1hEppaSZi8CWRGHDARbqX7oFQIeWxIQnSaW2elIlb2XM7yf
        kRJo9JF2uhpVgCrcfJpQ9guC09/0qaL1dbzv0X0WtLYidCDYJ0x2GO2OsRqez9KTqT8ll1
        0IAgzio8b2tMVhdOSL+KY+UKt4UVxPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654786414;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3aO+2GrWqukkSEEG3uFZkKnaxnzcC/J8dSBs7I2GU8=;
        b=UVKTNnF6lDPWrGc8TPAR66NpTm6Z7Rchz19G8r5lXh2chdHUE6ofdCEhVRZsDPvMi8qYJ9
        VDubRdvGzBF7ObBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C343813A8C;
        Thu,  9 Jun 2022 14:53:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /Y6YLG0JomLbewAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 14:53:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 8f863065;
        Thu, 9 Jun 2022 14:54:15 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     David Disseldorp <ddiss@suse.de>
Cc:     fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
References: <20220609105343.13591-1-lhenriques@suse.de>
        <20220609105343.13591-2-lhenriques@suse.de>
        <20220609162109.23883b71@suse.de>
Date:   Thu, 09 Jun 2022 15:54:15 +0100
In-Reply-To: <20220609162109.23883b71@suse.de> (David Disseldorp's message of
        "Thu, 9 Jun 2022 16:21:09 +0200")
Message-ID: <87h74t51m0.fsf@brahms.olymp>
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

David Disseldorp <ddiss@suse.de> writes:

> Hi Lu=C3=ADs,
>
> On Thu,  9 Jun 2022 11:53:42 +0100, Lu=C3=ADs Henriques wrote:
>
>> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
>> size for the full set of xattrs names+values, which by default is 64K.
>>=20
>> This patch fixes the max_attrval_size so that it is slightly < 64K in
>> order to accommodate any already existing xattrs in the file.
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  tests/generic/020 | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/tests/generic/020 b/tests/generic/020
>> index d8648e96286e..76f13220fe85 100755
>> --- a/tests/generic/020
>> +++ b/tests/generic/020
>> @@ -128,7 +128,7 @@ _attr_get_max()
>>  	pvfs2)
>>  		max_attrval_size=3D8192
>>  		;;
>> -	xfs|udf|9p|ceph)
>> +	xfs|udf|9p)
>>  		max_attrval_size=3D65536
>>  		;;
>>  	bcachefs)
>> @@ -139,6 +139,14 @@ _attr_get_max()
>>  		# the underlying filesystem, so just use the lowest value above.
>>  		max_attrval_size=3D1024
>>  		;;
>> +	ceph)
>> +		# CephFS does not have a maximum value for attributes.  Instead,
>> +		# it imposes a maximum size for the full set of xattrs
>> +		# names+values, which by default is 64K.  Set this to a value
>> +		# that is slightly smaller than 64K so that it can accommodate
>> +		# already existing xattrs.
>> +		max_attrval_size=3D65000
>> +		;;
>
> I take it a more exact calculation would be something like:
> (64K - $max_attrval_namelen - sizeof(user.snrub=3D"fish2\012"))?
>
> Perhaps you could calculate this on the fly for CephFS by passing in the
> filename and subtracting the `getfattr -d $filename` results... That
> said, it'd probably get a bit ugly, expecially if encoding needs to be
> taken into account.

In fact, this is *exactly* what I had before Dave suggested to keep it
simple.  After moving the code back into common/attr, where's how the
generic code would look like:

+       ceph)
+		# CephFS does have a limit for the whole set of names+values
+		# attributes in a file.  Thus, it is necessary to get the sizes
+		# of all names and values already existent and subtract them to
+		# the (default) maximum, which is 64k.
+		local len=3D0
+		while read line; do
+			# skip 1st line
+			[ "$line" !=3D "${line#'#'}" ] && continue
+			n=3D$(echo $line | awk -F"=3D0x" '{print $1}')
+			v=3D$(echo $line | awk -F"=3D0x" '{print $2}')
+			nlen=3D${#n}
+			vlen=3D${#v}
+			# total is the sum of the name len and the value len
+			# divided by 2 because we're dumping them in hex format
+			t=3D$(($nlen + $vlen / 2))
+			len=3D$(($len + $t))
+		done <<< $(_getfattr -d -e hex $file 2> /dev/null)
+		echo $((65536 - $max_attrval_namelen - $len))
+		;;

so... yeah, I'm not particularly gifted on shell, it could probably be
done in more clever/cleaner ways.  Anyway, I'm open to revisit this if
this is the preferred solution.

> Reviewed-by: David Disseldorp <ddiss@suse.de>

Thanks David.  (And sorry!  I completely forgot to include you on CC as I
had promised.)

Cheers,
--=20
Lu=C3=ADs
