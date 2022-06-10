Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BB54670C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 15:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbiFJNGK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbiFJNGI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 09:06:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBE92BE3;
        Fri, 10 Jun 2022 06:06:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 09CE51FD3A;
        Fri, 10 Jun 2022 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654866364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKJb2yfH7WGTf4bCkt05kUuUeC65zU/vhDKvaMT0Dhs=;
        b=2Lqshp+AZ7LtqYFPiXjc4+U3ZmuwncXJtZHTAQFPvBH0sruiKuWJY68JWBJ799eQ4GMhB1
        7gch7yZ6hjvoNU1u+fWUHcVdkyF5j28cVWZ2+9whTllbgMENeOVyKY8nrrbgB+dipiymDe
        PhBx5b+bU16hjusKZoEf3WAG1zvOwMA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654866364;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKJb2yfH7WGTf4bCkt05kUuUeC65zU/vhDKvaMT0Dhs=;
        b=q1msuJilxTSJ+eh7iSO+Qqz9V8XQl91RfV3ffsI6OgIypNQ+q7s+PsPXsh7c+hUW12/wKs
        SD5jCZQh4j6ut9BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8AAB913941;
        Fri, 10 Jun 2022 13:06:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zl3zHrtBo2K4QAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 10 Jun 2022 13:06:03 +0000
Received: from localhost (orpheu.olymp [local])
        by orpheu.olymp (OpenSMTPD) with ESMTPA id c5f5b6f9;
        Fri, 10 Jun 2022 14:06:01 +0100 (WEST)
From:   Luis Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     David Disseldorp <ddiss@suse.de>, fstests@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
References: <20220609105343.13591-1-lhenriques@suse.de>
        <20220609105343.13591-2-lhenriques@suse.de>
        <20220609162109.23883b71@suse.de>
        <c2f88303-5360-6dca-93f1-a488f39f2325@redhat.com>
Date:   Fri, 10 Jun 2022 14:06:01 +0100
In-Reply-To: <c2f88303-5360-6dca-93f1-a488f39f2325@redhat.com> (Xiubo Li's
        message of "Fri, 10 Jun 2022 08:47:09 +0800")
Message-ID: <87k09ou0qu.fsf@orpheu.olymp>
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

Xiubo Li <xiubli@redhat.com> writes:

> On 6/9/22 10:21 PM, David Disseldorp wrote:
>> Hi Lu=C3=ADs,
>>
>> On Thu,  9 Jun 2022 11:53:42 +0100, Lu=C3=ADs Henriques wrote:
>>
>>> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
>>> size for the full set of xattrs names+values, which by default is 64K.
>>>
>>> This patch fixes the max_attrval_size so that it is slightly < 64K in
>>> order to accommodate any already existing xattrs in the file.
>>>
>>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>> ---
>>>   tests/generic/020 | 10 +++++++++-
>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tests/generic/020 b/tests/generic/020
>>> index d8648e96286e..76f13220fe85 100755
>>> --- a/tests/generic/020
>>> +++ b/tests/generic/020
>>> @@ -128,7 +128,7 @@ _attr_get_max()
>>>   	pvfs2)
>>>   		max_attrval_size=3D8192
>>>   		;;
>>> -	xfs|udf|9p|ceph)
>>> +	xfs|udf|9p)
>>>   		max_attrval_size=3D65536
>>>   		;;
>>>   	bcachefs)
>>> @@ -139,6 +139,14 @@ _attr_get_max()
>>>   		# the underlying filesystem, so just use the lowest value above.
>>>   		max_attrval_size=3D1024
>>>   		;;
>>> +	ceph)
>>> +		# CephFS does not have a maximum value for attributes.  Instead,
>>> +		# it imposes a maximum size for the full set of xattrs
>>> +		# names+values, which by default is 64K.  Set this to a value
>>> +		# that is slightly smaller than 64K so that it can accommodate
>>> +		# already existing xattrs.
>>> +		max_attrval_size=3D65000
>>> +		;;
>> I take it a more exact calculation would be something like:
>> (64K - $max_attrval_namelen - sizeof(user.snrub=3D"fish2\012"))?
>
> Yeah, something like this looks better to me.

Right, it could be hard-coded.  But we'd need to take into account that
the attribute value may not be ascii.  That's why my initial attempt to
fix this was to decode everything in hex.

> I am afraid without reaching up to the real max size we couldn't test the=
 real
> bugs out from ceph. Such as the bug you fixed in ceph Locker.cc code.

OK, I'll change this to use the exact value.  Thanks, Xiubo.

Cheers,
--=20
Luis

>
>> Perhaps you could calculate this on the fly for CephFS by passing in the
>> filename and subtracting the `getfattr -d $filename` results... That
>> said, it'd probably get a bit ugly, expecially if encoding needs to be
>> taken into account.
>>
>> Reviewed-by: David Disseldorp <ddiss@suse.de>
>>
>> Cheers, David
>>
>
