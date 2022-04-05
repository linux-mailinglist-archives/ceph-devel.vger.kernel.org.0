Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF67E4F20F7
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Apr 2022 06:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiDECrM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Apr 2022 22:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiDECrG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Apr 2022 22:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D20710C4;
        Mon,  4 Apr 2022 19:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0D1561780;
        Tue,  5 Apr 2022 00:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A61BC2BBE4;
        Tue,  5 Apr 2022 00:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649118237;
        bh=Gh8XVrQsTyAaSICz3F/f3am3Za1MFqQqcBv7hvPdqAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dHuymffEvh8QVEb0Gcpgng7znoDk6Lp7JrVZv/JKAckVCyi3E6m1t/qGeFlzI4jz6
         C7RVkb7bYI1N89LH7eZ2dGbWt//bUGlgzl3DkC66+qKcXF2G4AoyPGyy0J2s+Nzvyd
         NLeDMuAbDrPseetQXd5uEFs8do7+2wiqfs8KaMZk8eNsp8jdkK9Orb/jzpQjxqN5+/
         80HEGOEiaOLOjvHwuAk9Ih8JTc56dXXvLa34TIw3YwIn3zIAYRDy6/YTSd0m2+BymP
         0pXWowwXHJYckAZOthP2Ow9GwsvHc+PF9iK+fAsCgEQ5vten+uaVdCqMQmWROSCBY8
         8W8KZiMWpyRxw==
Date:   Mon, 4 Apr 2022 17:23:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] common/encrypt: allow the use of 'fscrypt:' as key
 prefix
Message-ID: <YkuMG5MH17qkS0EA@sol.localdomain>
References: <20220404102554.6616-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220404102554.6616-1-lhenriques@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The code looks fine, but the explanation needs some tweaks:

On Mon, Apr 04, 2022 at 11:25:54AM +0100, Luís Henriques wrote:
> fscrypt keys have used the $FSTYP as prefix.  However this format is being
> deprecated -- newer kernels already allow the usage of the generic
> 'fscrypt:' prefix for ext4 and f2fs.  This patch allows the usage of this
> new prefix for testing filesystems that have never supported the old
> format, but keeping the $FSTYP prefix for filesystems that support it, so
> that old kernels can be tested.

This explanation is inconsistent with the code, which uses FSTYP for only ext4
and f2fs, and fscrypt for everything else including ubifs.

A better explanation would be something like "Only use $FSTYP on filesystems
that never supported the 'fscrypt' prefix, i.e. ext4 and f2fs."

> +# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key descriptor
> +# hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6 and later) also allow
> +# the common key prefix "fscrypt:" in addition to their filesystem-specific key
> +# prefix ("ext4:", "f2fs:").  It would be nice to use the common key prefix, but
> +# for now use the filesystem- specific prefix for these 2 filesystems to make it
> +# possible to test older kernels, and the "fscrypt" prefix for anything else.
> +_get_fs_keyprefix()

The first part of this comment sort of implies that FSTYP is the default and
"fscrypt" is the exception, but it should be the other way around.

How about:

# When fscrypt keys are added using the legacy mechanism (process-subscribed
# keyrings rather than filesystem keyrings), they are normally named
# "fscrypt:KEYDESC" where KEYDESC is the 16-character key descriptor hex string.
# However, ext4 and f2fs didn't add support for the "fscrypt" prefix until
# kernel v4.8 and v4.6, respectively.  Before that, they used "ext4" and "f2fs",
# respectively.  To allow testing ext4 and f2fs encryption on kernels older than
# this, we use these filesystem-specific prefixes for ext4 and f2fs.
