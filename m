Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2142C5A4E26
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Aug 2022 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiH2Nb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Aug 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiH2Nbg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Aug 2022 09:31:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CE86178;
        Mon, 29 Aug 2022 06:31:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 48ACD1F8A6;
        Mon, 29 Aug 2022 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661779894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wUZND/DKJkv5CHhdHAcqADwij1sZ+Y21qPUdtI+TNI=;
        b=S7TtLjoOOl26SxHXf3KHrHOnWhkl0SmHP4OKPTe/36NGyp8fyRLvvzYHd8c34ddN+oh/C1
        wc8VFPOtFQRBkt4nrvJe3Oobm3EqkrczeBJ/6W6rWKsZQRI5Yw3oSTpluOa65ssGWoma4q
        YvF+HntEQrLxi9BPssii0lyp/Ujicpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661779894;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wUZND/DKJkv5CHhdHAcqADwij1sZ+Y21qPUdtI+TNI=;
        b=JtOxM3PVM09V4G+AO4/9/ptlKqtJXJ/7Ah3K5hRSgrGTXH+AwGzVepJBeno96ts1OZGwdy
        n8fp7JMCREQUHDDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD92E1352A;
        Mon, 29 Aug 2022 13:31:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kAMjJ7W/DGMfUwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 29 Aug 2022 13:31:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 13442315;
        Mon, 29 Aug 2022 13:32:26 +0000 (UTC)
Date:   Mon, 29 Aug 2022 14:32:26 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ddiss@suse.de, zlang@redhat.com,
        david@fromorbit.com, djwong@kernel.org, jlayton@kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph/004: fix the ceph.quota.max_bytes values
Message-ID: <Ywy/6qu+OzlWjhwq@suse.de>
References: <20220829070921.547074-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220829070921.547074-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 29, 2022 at 03:09:21PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Cephfs has required that the quota.max_bytes must be aligned to
> 4MB if greater than or equal to 4MB, otherwise must align to 4KB.

Although the MDS change that will force this hasn't yet been merged, this
test change looks reasonable anyway.  Feel free to add my:

Reviewed-by: Luís Henriques <lhenriques@suse.de>

Cheers,
--
Luís

> 
> URL: https://tracker.ceph.com/issues/57321
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  tests/ceph/004 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/ceph/004 b/tests/ceph/004
> index dbca713e..124ed1bc 100755
> --- a/tests/ceph/004
> +++ b/tests/ceph/004
> @@ -9,7 +9,7 @@
>  #
>  #    mkdir files limit
>  #    truncate files/file -s 10G
> -#    setfattr limit -n ceph.quota.max_bytes -v 1000000
> +#    setfattr limit -n ceph.quota.max_bytes -v 1048576
>  #    mv files limit/
>  #
>  # Because we're creating a new file and truncating it, we have Fx caps and thus
> @@ -76,9 +76,9 @@ check_Fs_caps()
>  }
>  
>  # set quota to 1m
> -$SETFATTR_PROG -n ceph.quota.max_bytes -v 1000000 $dest
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 1048576 $dest
>  # set quota to 20g
> -$SETFATTR_PROG -n ceph.quota.max_bytes -v 20000000000 $orig2
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 21474836480 $orig2
>  
>  #
>  # The following 2 testcases shall fail with either -EXDEV or -EDQUOT
> -- 
> 2.36.0.rc1
> 
