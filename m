Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8B65456D2
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 00:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiFIWAH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 18:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiFIWAG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 18:00:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DA416087F;
        Thu,  9 Jun 2022 15:00:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EEC771F928;
        Thu,  9 Jun 2022 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654812003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTcQRG6LqBok8mSIWtXx9a+E9QNBH9UU5PziKbQT8A0=;
        b=s50MQ9eRi0O8AtrMElGI6uHu97RicFdWVXqm/7l8KRLzJRpfy2cbwkLNHgO/rqug0ODFAl
        NTM/lDl/GgbC3yfyG8xavY+cSUn8FY+lJaE7M56XsQ99CyEuRkZ9Vzw0F97faJ/XMNRymI
        Ajpy6qelOsDXYX8A6BCdlZn7fSizVvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654812003;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTcQRG6LqBok8mSIWtXx9a+E9QNBH9UU5PziKbQT8A0=;
        b=AGnnuPmKgVfACKlHwr9H4UNvaVm3wfcD81hWD0ddK1XTAvndsRft05K7ooGVED6oG7C5If
        8xYgj2yXpfGfW/Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0D3A13A8C;
        Thu,  9 Jun 2022 22:00:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TA6kKWNtomIdEwAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 09 Jun 2022 22:00:03 +0000
Date:   Fri, 10 Jun 2022 00:00:02 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     =?UTF-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <20220610000002.45aa2cb5@suse.de>
In-Reply-To: <87h74t51m0.fsf@brahms.olymp>
References: <20220609105343.13591-1-lhenriques@suse.de>
        <20220609105343.13591-2-lhenriques@suse.de>
        <20220609162109.23883b71@suse.de>
        <87h74t51m0.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Thu, 09 Jun 2022 15:54:15 +0100, Lu=C3=ADs Henriques wrote:

> David Disseldorp <ddiss@suse.de> writes:
...
> > I take it a more exact calculation would be something like:
> > (64K - $max_attrval_namelen - sizeof(user.snrub=3D"fish2\012"))?
> >
> > Perhaps you could calculate this on the fly for CephFS by passing in the
> > filename and subtracting the `getfattr -d $filename` results... That
> > said, it'd probably get a bit ugly, expecially if encoding needs to be
> > taken into account. =20
>=20
> In fact, this is *exactly* what I had before Dave suggested to keep it
> simple.

Arg, sorry I missed your previous round.

> After moving the code back into common/attr, where's how the
> generic code would look like:
>=20
> +       ceph)
> +		# CephFS does have a limit for the whole set of names+values
> +		# attributes in a file.  Thus, it is necessary to get the sizes
> +		# of all names and values already existent and subtract them to
> +		# the (default) maximum, which is 64k.
> +		local len=3D0
> +		while read line; do
> +			# skip 1st line
> +			[ "$line" !=3D "${line#'#'}" ] && continue
> +			n=3D$(echo $line | awk -F"=3D0x" '{print $1}')
> +			v=3D$(echo $line | awk -F"=3D0x" '{print $2}')
> +			nlen=3D${#n}
> +			vlen=3D${#v}
> +			# total is the sum of the name len and the value len
> +			# divided by 2 because we're dumping them in hex format
> +			t=3D$(($nlen + $vlen / 2))
> +			len=3D$(($len + $t))
> +		done <<< $(_getfattr -d -e hex $file 2> /dev/null)
> +		echo $((65536 - $max_attrval_namelen - $len))
> +		;;
>=20
> so... yeah, I'm not particularly gifted on shell, it could probably be
> done in more clever/cleaner ways.  Anyway, I'm open to revisit this if
> this is the preferred solution.

hmm, I was hoping something like...
(( 65536 - $max_attrval_namelen - $(getfattr -d $file | _filter | wc -c) ))
would be possible, but getfattr output does make it a bit too messy.

Cheers, David
