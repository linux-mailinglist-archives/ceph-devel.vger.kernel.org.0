Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B695A51DBBD
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442784AbiEFPUM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442758AbiEFPUG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 11:20:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 374856D188
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 08:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651850181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hbOt6ZKTIw/1fgFfEx38ZCmm/+FmfbKtkJ1E4fnQJ3w=;
        b=S7s3VDuL8IIg3BL0TXjpxQSGdfCa9piv/BxWG7vSjcWD2LZk7SKg5Fv6EttBnvfw0+I5j8
        J27HaT98z3c/TUq9+IuEQB7NwBk+qAdnzjsiLwBp1LRLtxD7UwmhD24EqeXyi4aTM1nnQ+
        mqhsWcTDiodCpfqi4MQymBiRETEx17A=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-sII5H6FZOaub_ccunrLbfw-1; Fri, 06 May 2022 11:16:20 -0400
X-MC-Unique: sII5H6FZOaub_ccunrLbfw-1
Received: by mail-pj1-f72.google.com with SMTP id m6-20020a17090a730600b001d9041534e4so3673817pjk.7
        for <ceph-devel@vger.kernel.org>; Fri, 06 May 2022 08:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hbOt6ZKTIw/1fgFfEx38ZCmm/+FmfbKtkJ1E4fnQJ3w=;
        b=Os4uTrJi7hLoxCooDyOpo7HDKBmSX8Q5DvN91S1pBq88GuZ0JMGg80kVpNntL9s3Ra
         /PapCtoxI5aB1zz6tOXcwIRX0OECYPfiglquu4hc/RsV0miifLhdv+itOjdLG3Fq6AZa
         o/6w6ML+HwhGnVNHHHV6lMPTsdnThMv7IP/rig/hSbR6G5uyqcO2DsBUyq0/it/fIxDa
         OC2oUUrKnFqAgEwIXvBIpQmlwLTs2KHDqNxS1rFyhAPBdiMEocul4+8mhX0t0w3T2s/G
         D+6nv50ctkK6u8G38yXWVA/NxbKIfuscdOrn6B28KuXeo26dNFD1vA5b28UwyjAT66V4
         UXkg==
X-Gm-Message-State: AOAM533Vme/8sKqVbUTPNzx/rkSDV8FqXtAc6KycCVALJLxSu9RJat9N
        K77S0ov9Z0ttnvFBCSJfWW+i+9faI/4Kz3TiLCN/gtU/axM2tbs4AdBu2VG6dKwjBj9saQgHkcO
        fTKeEIbjN+yfFpPMRHuYXSnhGQW0MmHtDU2GRnrHtwkCKOWbMk+hdoPz7P5CqRaaKK04gluY=
X-Received: by 2002:a63:1c5:0:b0:39c:c779:b480 with SMTP id 188-20020a6301c5000000b0039cc779b480mr3089168pgb.311.1651850178608;
        Fri, 06 May 2022 08:16:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwq64JUPvx1nZs+UbMTWC64lBl4meD77GQEUeavKh55BZi6NCwifkHG6RGBWMa+13BXbAGKQ==
X-Received: by 2002:a63:1c5:0:b0:39c:c779:b480 with SMTP id 188-20020a6301c5000000b0039cc779b480mr3089149pgb.311.1651850178214;
        Fri, 06 May 2022 08:16:18 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79485000000b0050dc76281acsm3573136pfk.134.2022.05.06.08.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 08:16:17 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: always try to uninline inline data when opening
 files
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220506143052.479799-1-xiubli@redhat.com>
 <aa0ea51647c660b50bbfd9b2087cba4f24938ee0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8aa0e706-f389-be9e-f2de-17d095fa6ce0@redhat.com>
Date:   Fri, 6 May 2022 23:16:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <aa0ea51647c660b50bbfd9b2087cba4f24938ee0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/6/22 10:52 PM, Jeff Layton wrote:
> On Fri, 2022-05-06 at 22:30 +0800, Xiubo Li wrote:
>> This will help reduce possible deadlock while holding Fcr to use
>> getattr for read case.
>>
>> Usually we shouldn't use getattr to fetch inline data after getting
>> Fcr caps, because it can cause deadlock. The solution is try uniline
>> the inline data when opening files, thanks David Howells' previous
>> work on uninlining the inline data work.
>>
>> It was caused from one possible call path:
>>    ceph_filemap_fault()-->
>>       ceph_get_caps(Fcr);
>>       filemap_fault()-->
>>          do_sync_mmap_readahead()-->
>>             page_cache_ra_order()-->
>>                read_pages()-->
>>                   aops->readahead()-->
>>                      netfs_readahead()-->
>>                         netfs_begin_read()-->
>>                            netfs_rreq_submit_slice()-->
>>                               netfs_read_from_server()-->
>>                                  netfs_ops->issue_read()-->
>>                                     ceph_netfs_issue_read()-->
>>                                        ceph_netfs_issue_op_inline()-->
>>                                           getattr()
>>        ceph_pu_caps_ref(Fcr);
>>
>> This because if the Locker state is LOCK_EXEC_MIX for auth MDS, and
>> the replica MDSes' lock state is LOCK_LOCK. Then the kclient could
>> get 'Frwcb' caps from both auth and replica MDSes.
>>
>> But if the getattr is sent to any MDS, the MDS needs to do Locker
>> transition to LOCK_MIX first and then to LOCK_SYNC. But when
>> transfering to LOCK_MIX state the MDS Locker need to revoke the Fcb
>> caps back, but the kclient already holding it and waiting the MDS
>> to finish.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 8c8226c0feac..09327ef5a26d 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -241,11 +241,12 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>>   	INIT_LIST_HEAD(&fi->rw_contexts);
>>   	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>>   
>> -	if ((file->f_mode & FMODE_WRITE) &&
>> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
>> -		ret = ceph_uninline_data(file);
>> -		if (ret < 0)
>> -			goto error;
>> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>> +		if (!ceph_pool_perm_check(inode, CEPH_CAP_FILE_WR)) {
>> +			ret = ceph_uninline_data(file);
>> +			if (ret < 0)
>> +				goto error;
>> +		}
>>   	}
>>   
>>   	return 0;
> Note that this may be considered a regression in some cases. If a client
> doesn't have write permissions to the pool at all, then previously it'd
> be able to read files, but now it wouldn't.

Only when the pool has write permission will it try to uninline the 
inline data. Or we will skip it.

Maybe we should ignore the error in read case ?


> Those are not terribly common configurations as I understand, but we
> should be aware of it if we go this route.
>
> Beyond that though, this patch ignores errors from ceph_pool_perm_check
> and doesn't uninline the file if one is returned. Is that the behavior
> you want here?

Yeah, I ignored them on purpose.  Even uninlining the inline_data fails 
shall we continue IMO.


