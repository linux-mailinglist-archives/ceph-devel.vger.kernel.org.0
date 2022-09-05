Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560DF5AD320
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Sep 2022 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiIEMsI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Sep 2022 08:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiIEMrw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Sep 2022 08:47:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F087E1D
        for <ceph-devel@vger.kernel.org>; Mon,  5 Sep 2022 05:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662381954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzKopZpNwG1zS4XEeOMDf1nFZUi0X31U7WjbzxthDo0=;
        b=g77DK4H1iYyddYryutWy/BCgMnMYsx9IyYcDt1+MptoE4KpTDIvJssxKz9hSUbpOrJsKDk
        pqfAdSCWAngjzbuqAe+AXz5788QOse97K0FMGdqeZzE4TbyzKDQVz2Gh7BGswZ+dNuqW6C
        dmoFw7S8EbJPy/baKdus96OPSjWg4wo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-weQch4pUMFSvbfYAAbHSmA-1; Mon, 05 Sep 2022 08:45:53 -0400
X-MC-Unique: weQch4pUMFSvbfYAAbHSmA-1
Received: by mail-pg1-f199.google.com with SMTP id k16-20020a635a50000000b0042986056df6so4375772pgm.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Sep 2022 05:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TzKopZpNwG1zS4XEeOMDf1nFZUi0X31U7WjbzxthDo0=;
        b=NngCxDJ97lNcJpckg5CUeg6HjFrapk9g9LhB1pejoKjTSUx+PD20qjzTewVL9SHiUR
         PP8vgH+Yth/xrMfMO5jIp3QCCK/lRq2jOSvF9nlHZu1D4zy+2yqZzYijByhFXPD1di2v
         W6nvxYTm48baxRJI7t8lH5Z36kO7fTmckA7Ezgg2c3Hc6K9TnYypk7yBgpXnVxkj6DnQ
         DL7tgTJfrWkxaKfQU/mwm4A6OZYJ7mwuag8bJvaPe898uh6TVwMt8noitKkoeTJCWFo3
         ZQSs8QbsmOMbYOK9ldqeOmfaBNuZyPYBYaLjAmG7/WnbuCTxfyusL4rl1rqqcf6+2BJn
         JyOA==
X-Gm-Message-State: ACgBeo2pQCrcV0dQan1wtMEqeCWCccMxl+Y8bRrqtbgPwyaPPQB0Zm2q
        w6VTBgVrE4vzw2PvtWjiH/K6Fq6Dfn3dlOIhaJEmDM7m/NclUXmxe9LBmTTbwVJKm+xsYF5oeI1
        G44jOOQbxp3FQmVe/HwnI/g==
X-Received: by 2002:a63:8849:0:b0:434:efd:6bbf with SMTP id l70-20020a638849000000b004340efd6bbfmr9196315pgd.312.1662381952149;
        Mon, 05 Sep 2022 05:45:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR40Klo9PuiJXlMUV3ENGhfMw1WC9PYebMx9V6cf5LYRXofLOzR5GF/HVYSAC9gCxS84WX3A8g==
X-Received: by 2002:a63:8849:0:b0:434:efd:6bbf with SMTP id l70-20020a638849000000b004340efd6bbfmr9196296pgd.312.1662381951845;
        Mon, 05 Sep 2022 05:45:51 -0700 (PDT)
Received: from [10.72.12.45] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00000c00b00535e49245d6sm7895371pfk.12.2022.09.05.05.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 05:45:51 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fix incorrectly showing the .snap size for stat
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com,
        mchangir@redhat.com
References: <20220831080257.170065-1-xiubli@redhat.com>
 <YxXU9YZ1/8fPApvp@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <675767c4-b69f-7c5b-48cd-33a7afa07768@redhat.com>
Date:   Mon, 5 Sep 2022 20:45:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YxXU9YZ1/8fPApvp@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 05/09/2022 18:52, Luís Henriques wrote:
> On Wed, Aug 31, 2022 at 04:02:57PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We should set the 'stat->size' to the real number of snapshots for
>> snapdirs.
>>
>> URL: https://tracker.ceph.com/issues/57342
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 66 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 4db4394912e7..99022bcdde64 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2705,6 +2705,52 @@ static int statx_to_caps(u32 want, umode_t mode)
>>   	return mask;
>>   }
>>   
>> +static struct inode *ceph_get_snap_parent(struct inode *inode)
>> +{
>> +	struct super_block *sb = inode->i_sb;
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
>> +	struct ceph_mds_request *req;
>> +	struct ceph_vino vino = {
>> +		.ino = ceph_ino(inode),
>> +		.snap = CEPH_NOSNAP,
>> +	};
>> +	struct inode *parent;
>> +	int mask;
>> +	int err;
>> +
>> +	if (ceph_vino_is_reserved(vino))
>> +		return ERR_PTR(-ESTALE);
>> +
>> +	parent = ceph_find_inode(sb, vino);
>> +	if (likely(parent)) {
>> +		if (ceph_inode_is_shutdown(parent)) {
>> +			iput(parent);
>> +			return ERR_PTR(-ESTALE);
>> +		}
>> +		return parent;
>> +	}
>> +
>> +	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
>> +				       USE_ANY_MDS);
>> +	if (IS_ERR(req))
>> +		return ERR_CAST(req);
>> +
>> +	mask = CEPH_STAT_CAP_INODE;
>> +	if (ceph_security_xattr_wanted(d_inode(sb->s_root)))
>> +		mask |= CEPH_CAP_XATTR_SHARED;
>> +	req->r_args.lookupino.mask = cpu_to_le32(mask);
>> +	req->r_ino1 = vino;
>> +	req->r_num_caps = 1;
>> +	err = ceph_mdsc_do_request(mdsc, NULL, req);
>> +	if (err < 0)
>> +		return ERR_PTR(err);
>> +	parent = req->r_target_inode;
>> +	if (!parent)
>> +		return ERR_PTR(-ESTALE);
>> +	ihold(parent);
>> +	return parent;
>> +}
> Can't we simply re-use __lookup_inode() instead of duplicating all this
> code?

It seems working.

Let me check more about that.

> (Also: is there a similar fix for the fuse client?)

Yeah, I have raised one PR for that already.

Thanks Luis!


> Cheers,
> --
> Luís
>
>> +
>>   /*
>>    * Get all the attributes. If we have sufficient caps for the requested attrs,
>>    * then we can avoid talking to the MDS at all.
>> @@ -2748,10 +2794,28 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>>   
>>   	if (S_ISDIR(inode->i_mode)) {
>>   		if (ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb),
>> -					RBYTES))
>> +					RBYTES)) {
>>   			stat->size = ci->i_rbytes;
>> -		else
>> +		} else if (ceph_snap(inode) == CEPH_SNAPDIR) {
>> +			struct inode *parent = ceph_get_snap_parent(inode);
>> +			struct ceph_inode_info *pci;
>> +			struct ceph_snap_realm *realm;
>> +
>> +			if (!parent)
>> +				return PTR_ERR(parent);
>> +
>> +			pci = ceph_inode(parent);
>> +			spin_lock(&pci->i_ceph_lock);
>> +			realm = pci->i_snap_realm;
>> +			if (realm)
>> +				stat->size = realm->num_snaps;
>> +			else
>> +				stat->size = 0;
>> +			spin_unlock(&pci->i_ceph_lock);
>> +			iput(parent);
>> +		} else {
>>   			stat->size = ci->i_files + ci->i_subdirs;
>> +		}
>>   		stat->blocks = 0;
>>   		stat->blksize = 65536;
>>   		/*
>> -- 
>> 2.36.0.rc1
>>

