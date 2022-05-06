Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5AB51D7C2
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 14:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356934AbiEFMe3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 08:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392216AbiEFMeL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 08:34:11 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22BCA692AA
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 05:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651840185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4ypAIu0U1AB+3rQppHCQkZrvnfmhDZcxkGfWbyZraY=;
        b=D6jBMMvpM8iUJOWRQppwf2oZgj76fvnD9btOGmaTDMh2oYDCBXp2+DpXBPTER4kdgW6nKR
        NuPFghhhXzXNarkCRfvZTsyMCg0Yu9HsIARRHKyWN9AoMv+YfyIYHr41O1A7vnUWTsQkQ8
        usSOlG/gD5damq6Zox8tfaO62GY/2zk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-aQyvyMgZOwygINpGayeMzA-1; Fri, 06 May 2022 08:29:44 -0400
X-MC-Unique: aQyvyMgZOwygINpGayeMzA-1
Received: by mail-pl1-f198.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so3878666plg.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 May 2022 05:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=O4ypAIu0U1AB+3rQppHCQkZrvnfmhDZcxkGfWbyZraY=;
        b=lpZEVWFCNaZLyItDB/qo1BsSdbzNqEHmLWumNaqldD5rloKzZrGMrEpDMlbrCF7MiE
         qsTOVVBP+EMPixIe2mjFi6jpnzqcA9f5HDqK00T7TJYQFSKdsU/GLxcX6smArCZt4hpu
         txGzyRzWU8hk0kTZZ0y/sCR3XmClACLgg2im5qvbyG1/RfW/k3x+0pr59r4FycVwbPDT
         8ynKApFfM/Q/hnH70E4+vkcQPYTINdiZojUtBNQRn6b4K1Q4AP+Siln0xq9D0Y4pJ9Sn
         SjE1BZPRZ6DnkuAuDe6/0X3wN5g+Az4jSvk8Ur8unuMGDylBSkEPMdctLX3/2dUnNbgh
         W+JA==
X-Gm-Message-State: AOAM532uV7laH9BxkBshM+6KxpXhf5kBJj87uZmriwhs82s8mXW629SH
        9lis6TxoLRfLqqwPGHcoU6QJaFk0imDy6kA8EFPlVJ9torvlXvtDWdE1oslZEH4NrG5BH497OP+
        kEVWRaqBEdkeMTjEqnazhRg==
X-Received: by 2002:a17:902:bf45:b0:15c:df47:3d6 with SMTP id u5-20020a170902bf4500b0015cdf4703d6mr3443647pls.58.1651840182783;
        Fri, 06 May 2022 05:29:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoAdDspxc8tbXsdncX7U+x95FHhoHSbJ/8F46jncvi/m8kgouEuhOkW3clgTvXMjNZVXuc/g==
X-Received: by 2002:a17:902:bf45:b0:15c:df47:3d6 with SMTP id u5-20020a170902bf4500b0015cdf4703d6mr3443625pls.58.1651840182478;
        Fri, 06 May 2022 05:29:42 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902e9d300b0015e8d4eb253sm1602350plk.157.2022.05.06.05.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 05:29:41 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix possible deadlock while holding Fcr to use
 getattr
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <20220422092520.18505-1-xiubli@redhat.com>
 <8cf47d9bd785ab474553e819604abd3008e0a24f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <81472085-eb82-aa98-d881-e1537bd1b9b6@redhat.com>
Date:   Fri, 6 May 2022 20:29:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8cf47d9bd785ab474553e819604abd3008e0a24f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 5/6/22 7:50 PM, Jeff Layton wrote:
> On Fri, 2022-04-22 at 17:25 +0800, Xiubo Li wrote:
>> We can't use getattr to fetch inline data after getting Fcr caps,
>> because it can cause deadlock. The solution is try uniline the
>> inline data when opening the file, thanks David Howells' previous
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
>>   fs/ceph/addr.c | 65 ++++++--------------------------------------------
>>   fs/ceph/file.c |  3 +--
>>   2 files changed, 8 insertions(+), 60 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 261bc8bb2ab8..b0b9a2f4adb0 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -244,61 +244,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
>>   	iput(req->r_inode);
>>   }
>>   
>> -static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
>> -{
>> -	struct netfs_io_request *rreq = subreq->rreq;
>> -	struct inode *inode = rreq->inode;
>> -	struct ceph_mds_reply_info_parsed *rinfo;
>> -	struct ceph_mds_reply_info_in *iinfo;
>> -	struct ceph_mds_request *req;
>> -	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
>> -	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	struct iov_iter iter;
>> -	ssize_t err = 0;
>> -	size_t len;
>> -	int mode;
>> -
>> -	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>> -	__clear_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
>> -
>> -	if (subreq->start >= inode->i_size)
>> -		goto out;
>> -
>> -	/* We need to fetch the inline data. */
>> -	mode = ceph_try_to_choose_auth_mds(inode, CEPH_STAT_CAP_INLINE_DATA);
>> -	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
>> -	if (IS_ERR(req)) {
>> -		err = PTR_ERR(req);
>> -		goto out;
>> -	}
>> -	req->r_ino1 = ci->i_vino;
>> -	req->r_args.getattr.mask = cpu_to_le32(CEPH_STAT_CAP_INLINE_DATA);
>> -	req->r_num_caps = 2;
>> -
>> -	err = ceph_mdsc_do_request(mdsc, NULL, req);
>> -	if (err < 0)
>> -		goto out;
>> -
>> -	rinfo = &req->r_reply_info;
>> -	iinfo = &rinfo->targeti;
>> -	if (iinfo->inline_version == CEPH_INLINE_NONE) {
>> -		/* The data got uninlined */
>> -		ceph_mdsc_put_request(req);
>> -		return false;
>> -	}
>> -
>> -	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
>> -	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
>> -	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);
>> -	if (err == 0)
>> -		err = -EFAULT;
>> -
>> -	ceph_mdsc_put_request(req);
>> -out:
>> -	netfs_subreq_terminated(subreq, err, false);
>> -	return true;
>> -}
>> -
>>   static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>   {
>>   	struct netfs_io_request *rreq = subreq->rreq;
>> @@ -313,9 +258,13 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>   	int err = 0;
>>   	u64 len = subreq->len;
>>   
>> -	if (ci->i_inline_version != CEPH_INLINE_NONE &&
>> -	    ceph_netfs_issue_op_inline(subreq))
>> -		return;
>> +	/*
>> +	 * We have uninlined the inline data when openning the file,
>> +	 * or we must send a GETATTR request to the MDS, which is
>> +	 * buggy and will cause deadlock while holding the Fcr
>> +	 * reference in ceph_filemap_fault().
>> +	 */
>> +	BUG_ON(ci->i_inline_version != CEPH_INLINE_NONE);
>>   
>>   	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
>>   			0, 1, CEPH_OSD_OP_READ,
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 6c9e837aa1d3..a98a61ec4ada 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -241,8 +241,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>>   	INIT_LIST_HEAD(&fi->rw_contexts);
>>   	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>>   
>> -	if ((file->f_mode & FMODE_WRITE) &&
>> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
>> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>>   		ret = ceph_uninline_data(file);
>>   		if (ret < 0)
>>   			goto error;
> Will we always be able to guarantee that we can uninline the file? I
> think it's possible to use RADOS pool caps to limit some clients to
> read-only. That's what ceph_pool_perm_check is all about.
>
> If we do want to go this route, then you may need to fix
> ceph_pool_perm_check to check for CEPH_I_POOL_WR when opening an inlined
> file for read.

Okay, I get what you mean here, I missed that part.

Will check it. Thanks!

-- Xiubo


