Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6C5028F2
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Apr 2022 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352728AbiDOLzx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Apr 2022 07:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiDOLzw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 15 Apr 2022 07:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABCCA27C0;
        Fri, 15 Apr 2022 04:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD801B82C41;
        Fri, 15 Apr 2022 11:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092BCC385A5;
        Fri, 15 Apr 2022 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650023601;
        bh=jhkF3tVBl7jIZs5cgBtmYhJC0qLpSqyjnYjj8g67Rg0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=niwXtS6U4KwVg+zXiPd+eFy7phcu40nxoCELTCkKhG9WLjECHuQBxNs4tlZdn/fMl
         +eKyyaX1+vCtyq2fK765AgnF7XKw7sr+yqH3pKy0R5OjBBHCJ6aQ70q7grXdboOfZS
         uIyoNMl2v8/4ozsAlypNJ3zN6WLM1p5GiudE1oAy8Yg9qdUnNk47MNlb/D+C/yo09y
         eySrN9As1Emtz0LV9qC4rxJnfUC8T6FyBjcLQnsvJgSFYHyr58cZjGTvTRHEpoDdW8
         bZCKA+7HeUTaOBXcbHFBa3QmeX93gA5meslmv/ZbEw+Q/AtpOVPmeHZ9OZXMb8baYK
         2cg1s9BaZ3XJw==
Message-ID: <2ddf7fd69e03409b0a868e0e3ff21f1491cb41ae.camel@kernel.org>
Subject: Re: [PATCH] ceph/001: add extra check for remote object copies
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org
Date:   Fri, 15 Apr 2022 07:53:19 -0400
In-Reply-To: <20220323160925.7142-1-lhenriques@suse.de>
References: <20220323160925.7142-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-23 at 16:09 +0000, Luís Henriques wrote:
> Ceph kernel client now has a facility to check stats for certain operations.
> One of these operations is the 'copyfrom', the operation that is used to offload
> to the OSDs the copy of objects from, for example, the copy_file_range()
> syscall.
> 
> This patch changes ceph/001 to add an extra check to verify that the copies
> performed by the test are _really_ remote copies and not simple read+write
> operations.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  common/ceph    | 10 ++++++++
>  tests/ceph/001 | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/common/ceph b/common/ceph
> index ca756dda8dd3..d6f24df177e7 100644
> --- a/common/ceph
> +++ b/common/ceph
> @@ -28,3 +28,13 @@ _require_ceph_vxattr_caps()
>  	$GETFATTR_PROG -n "ceph.caps" $TEST_DIR >/dev/null 2>&1 \
>  	  || _notrun "ceph.caps vxattr not supported"
>  }
> +
> +_ceph_get_cluster_fsid()
> +{
> +	$GETFATTR_PROG --only-values -n "ceph.cluster_fsid" $TEST_DIR 2>/dev/null
> +}
> +
> +_ceph_get_client_id()
> +{
> +	$GETFATTR_PROG --only-values -n "ceph.client_id" $TEST_DIR 2>/dev/null
> +}
> diff --git a/tests/ceph/001 b/tests/ceph/001
> index 5a828567d500..7970ce352bab 100755
> --- a/tests/ceph/001
> +++ b/tests/ceph/001
> @@ -30,6 +30,10 @@ workdir=$TEST_DIR/test-$seq
>  rm -rf $workdir
>  mkdir $workdir
>  
> +cluster_fsid=$(_ceph_get_cluster_fsid)
> +client_id=$(_ceph_get_client_id)
> +metrics_dir="$DEBUGFS_MNT/ceph/$cluster_fsid.$client_id/metrics"
> +
>  check_range()
>  {
>  	local file=$1
> @@ -40,8 +44,68 @@ check_range()
>  	[ $? -eq 0 ] && echo "file $file is not '$val' in [ $off0 $off1 ]"
>  }
>  
> +#
> +# The metrics file has the following fields:
> +#   1. item
> +#   2. total
> +#   3. avg_sz(bytes)
> +#   4. min_sz(bytes)
> +#   5. max_sz(bytes)
> +#   6. total_sz(bytes)
> +get_copyfrom_total_copies()
> +{
> +	local total=0
> +
> +	if [ -d $metrics_dir ]; then
> +		total=$(grep copyfrom $metrics_dir/size | tr -s '[:space:]' | cut -d ' ' -f 2)

Some older kernels didn't keep copyfrom stats, but any kernel that has a
$metrics_dir should have stats for copyfrom. This should be fine.

> +	fi
> +	echo $total
> +}
> +get_copyfrom_total_size()
> +{
> +	local total=0
> +
> +	if [ -d $metrics_dir ]; then
> +		total=$(grep copyfrom $metrics_dir/size | tr -s '[:space:]' | cut -d ' ' -f 6)
> +	fi
> +	echo $total
> +}
> +
> +# This function checks that the metrics file has the expected values for number
> +# of remote object copies and the total size of the copies.  For this, it
> +# expects a input:
> +#   $1 - initial number copies in metrics file (field 'total')
> +#   $2 - initial total size in bytes in metrics file (field 'total_sz')
> +#   $3 - object size used for copies
> +#   $4 - number of remote objects copied
> +check_copyfrom_metrics()
> +{
> +	local c0=$1
> +	local s0=$2
> +	local objsz=$3
> +	local copies=$4
> +	local c1=$(get_copyfrom_total_copies)
> +	local s1=$(get_copyfrom_total_size)
> +	local sum
> +
> +	if [ ! -d $metrics_dir ]; then
> +		return # skip metrics check if debugfs isn't mounted
> +	fi
> +
> +	sum=$(($c0+$copies))
> +	if [ $sum -ne $c1 ]; then
> +		echo "Wrong number of remote copies.  Expected $sum, got $c1"
> +	fi
> +	sum=$(($s0+$copies*$objsz))
> +	if [ $sum -ne $s1 ]; then
> +		echo "Wrong size of remote copies.  Expected $sum, got $s1"
> +	fi
> +}
> +
>  run_copy_range_tests()
>  {
> +	total_copies=$(get_copyfrom_total_copies)
> +	total_size=$(get_copyfrom_total_size)
>  	objsz=$1
>  	halfobj=$(($objsz / 2))
>  	file="$workdir/file-$objsz"
> @@ -203,6 +267,8 @@ run_copy_range_tests()
>  	check_range $dest $(($objsz * 2 + $halfobj)) $objsz 63
>  	check_range $dest $(($objsz * 3 + $halfobj)) $halfobj 64
>  
> +	# Confirm that we've done a total of 24 object copies
> +	check_copyfrom_metrics $total_copies $total_size $objsz 24
>  }
>  
>  echo "Object size: 65536" # CEPH_MIN_STRIPE_UNIT

LGTM

Reviewed-by: Jeff Layton <jlayton@kernel.org>
