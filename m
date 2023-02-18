Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B569B842
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Feb 2023 07:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBRGEm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Feb 2023 01:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRGEm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 18 Feb 2023 01:04:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A63410B9;
        Fri, 17 Feb 2023 22:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42A360A7C;
        Sat, 18 Feb 2023 06:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C5CC433EF;
        Sat, 18 Feb 2023 06:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676700280;
        bh=lNHGIKwPMkSzMLzrjZ3lzJub/iP4biinct6sJxTPaLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCi7Fp+i37jkGouqKxvL+XJuYniX+2bI2p4ZL5gfyOyHnE0mKFTOlgxPilcn+qmdR
         qlzaRsNFdxmnzPqKhs5K0IzwMhOMfX4panRMsegzHl5oxUuRo2AviRx+CZg+YZ0jx1
         xTGBINQBdZG1X3NTvuPusCAWlrFHbMXWdxLcRcZb0vc+pb9PKbKO8m/WBSloz0Ked7
         A5BL7z76TYc6PTCwXMmEMqziki3+sMDr4hVxl8KWDWa86D/c34gPHFtdXdfiMsY9pT
         C/UDJxyojsV5cguobSvYV4NdTFygNM6pDwqpBoGExeS8G7vYemMQddsn+NVMTlzsws
         xWKAmdck8G8uA==
Date:   Sat, 18 Feb 2023 14:04:36 +0800
From:   Zorro Lang <zlang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] generic/020: fix really long attr test failure for ceph
Message-ID: <20230218060436.534bnbs5znio5pd7@zlang-mailbox>
References: <20230217124558.555027-1-xiubli@redhat.com>
 <Y++0t8qxK8et8fTg@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y++0t8qxK8et8fTg@magnolia>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 17, 2023 at 09:09:11AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 17, 2023 at 08:45:58PM +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> > itself will set the security.selinux extended attribute to MDS.
> > And it will also eat some space of the total size.
> > 
> > Fixes: https://tracker.ceph.com/issues/58742
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  tests/generic/020 | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/generic/020 b/tests/generic/020
> > index be5cecad..594535b5 100755
> > --- a/tests/generic/020
> > +++ b/tests/generic/020
> > @@ -150,9 +150,11 @@ _attr_get_maxval_size()
> >  		# it imposes a maximum size for the full set of xattrs
> >  		# names+values, which by default is 64K.  Compute the maximum
> >  		# taking into account the already existing attributes
> > -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> > +		size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> >  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> > -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> > +		selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> > +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> > +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
> 
> If this is a ceph bug, then why is the change being applied to the
> section for FSTYP=ext* ?  Why not create a case statement for ceph?

Hi Darrick,

Looks like this change is in ceph section [1], did you hit any errors when
you merge it?

Thanks,
Zorro

[1]
_attr_get_maxval_size()
{
        local max_attrval_namelen="$1"
        local filename="$2"

        # Set max attr value size in bytes based on fs type
        case "$FSTYP" in
        ...
        ...
        ceph)
                # CephFS does not have a maximum value for attributes.  Instead,
                # it imposes a maximum size for the full set of xattrs
                # names+values, which by default is 64K.  Compute the maximum
                # taking into account the already existing attributes
====>           max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
                        awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
====>           max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))



> 
> --D
> 
> >  		;;
> >  	*)
> >  		# Assume max ~1 block of attrs
> > -- 
> > 2.31.1
> > 
> 
