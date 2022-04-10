Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402264FAE66
	for <lists+ceph-devel@lfdr.de>; Sun, 10 Apr 2022 17:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243257AbiDJPR1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Apr 2022 11:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241765AbiDJPR1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 10 Apr 2022 11:17:27 -0400
Received: from out20-73.mail.aliyun.com (out20-73.mail.aliyun.com [115.124.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAC629806;
        Sun, 10 Apr 2022 08:15:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=0.07440088|-1;BR=01201311R131ee;CH=green;DM=|CONTINUE|false|;DS=SPAM|spam_education_ad|0.99198-5.60615e-05-0.00796419;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.NNqAZEd_1649603711;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.NNqAZEd_1649603711)
          by smtp.aliyun-inc.com(33.37.72.134);
          Sun, 10 Apr 2022 23:15:12 +0800
Date:   Sun, 10 Apr 2022 23:15:11 +0800
From:   Eryu Guan <guan@eryu.me>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>,
        jlayton@kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ceph/001: add extra check for remote object copies
Message-ID: <YlL0f7DBVysxxbew@desktop>
References: <20220323160925.7142-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323160925.7142-1-lhenriques@suse.de>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

On Wed, Mar 23, 2022 at 04:09:25PM +0000, Luís Henriques wrote:
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

Would you please help review this cephfs test? Thanks!

Eryu

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
