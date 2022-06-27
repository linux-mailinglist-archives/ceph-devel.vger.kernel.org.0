Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F70155D251
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiF0KZI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 06:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiF0KZE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 06:25:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3705FEF;
        Mon, 27 Jun 2022 03:25:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DFC8121DC1;
        Mon, 27 Jun 2022 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656325501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KX+pPzQaWtY2xHRmJU4YFsbyspljUfyLuIN32LA2bso=;
        b=avioYxkbwGDrhDehAzrbK4MXn0v51Z8ch8s6UUyH3WsYBbSnPcUfHqZNRRv34vkC1rBjmx
        affoRSUOYyaKlmzulBMtGOp7UtOaQgdAykroA0yl77nfyFCWllT/a481Ij9Eg9Sm40nM3a
        6tCNeoyzeml8KA4/kx5x47AdNHsZY34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656325501;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KX+pPzQaWtY2xHRmJU4YFsbyspljUfyLuIN32LA2bso=;
        b=GXxXQ+CxDVRGZ+VK/e2c318f928xPiAOLLBFsgeXfVg1bOgl+oBNvlgUpq56i2++K3zPM3
        ufo/6xm38sh0ErBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 78CD413AB2;
        Mon, 27 Jun 2022 10:25:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +UuHGn2FuWIIRAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 27 Jun 2022 10:25:01 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 74f75799;
        Mon, 27 Jun 2022 10:25:48 +0000 (UTC)
Date:   Mon, 27 Jun 2022 11:25:48 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/005: verify correct statfs behaviour with quotas
Message-ID: <YrmFrMFP6I0+Bsej@suse.de>
References: <20220615151418.23805-1-lhenriques@suse.de>
 <1924a7cc-245d-f35b-5e7c-a82f36cf2271@redhat.com>
 <Yrl2ZXzOcwM6LCLe@suse.de>
 <034326ee-8018-aaeb-c918-efedc8a90eeb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <034326ee-8018-aaeb-c918-efedc8a90eeb@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 27, 2022 at 05:35:32PM +0800, Xiubo Li wrote:
<...>
> Sorry, could you give the link about this ?
> 
> Checked the xfs/234, I didn't find any place is using the similar pattern.
> 
> This is what I see:
> 
>  53 # Now restore the obfuscated one back and take a look around
>  54 echo "Restore metadump"
>  55 xfs_mdrestore $metadump_file $TEST_DIR/image
>  56 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>  57 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>  58
>  59 echo "Check restored fs"
>  60 _check_generic_filesystem $metadump_file
> 

Doh!  OK, you're right, looks like I'll need to change my glasses
graduation again.

> 
> > Anyway, if you prefer, I'm fine sending v3 of this test doing something
> > like:
> 
> Locally I just test this use case, it seems working as my guess.

That's odd.  Here's the test I've used locally to confirm it works:

8<----------------------------------------------------------------
#!/bin/bash

MYVAR="HELLO"

myfunc()
{
        echo "in function: $MYVAR"
}

MYVAR="$MYVAR WORLD" myfunc
MYVAR="$MYVAR WORLD" myfunc
myfunc
echo "$MYVAR"
8<----------------------------------------------------------------

When I run this in my laptop I see:

  in function: HELLO WORLD
  in function: HELLO WORLD
  in function: HELLO
  HELLO

Anyway, I think it's better to make this behaviour explicit in the test.
I'll send out v3 shortly.  Thanks Xiubo.

Cheers,
--
Luís
