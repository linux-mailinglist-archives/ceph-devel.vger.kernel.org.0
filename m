Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB2404403
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Sep 2021 05:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350113AbhIIDkN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 23:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235831AbhIIDkL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Sep 2021 23:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631158741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/scTe2tX3vho3jYGqG6txEbuQHp8Huxw8O5tQuNyTs=;
        b=YbHECJUhZIcU4ZaDf3QkzuZ+2QfWZFnvRqN1pTQn2abdRjTJtnGItPVDQfwg1TSgb03xo8
        UiB9DtsDHEA/RVoD/gNO8f7Pfpdzp/V3jyHSEg7i07ZjC79a/THEluz7agYfUaBSu/3H7K
        0R4mkeawL1dZ7pR0pguaOSjN0HdE+s8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-4jCl0hoOPcmTTm1LHr-9nA-1; Wed, 08 Sep 2021 23:39:00 -0400
X-MC-Unique: 4jCl0hoOPcmTTm1LHr-9nA-1
Received: by mail-pf1-f198.google.com with SMTP id 199-20020a6215d0000000b003f957128f82so465037pfv.18
        for <ceph-devel@vger.kernel.org>; Wed, 08 Sep 2021 20:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I/scTe2tX3vho3jYGqG6txEbuQHp8Huxw8O5tQuNyTs=;
        b=HTGT5NIJ8Xwi+PkAOQTg0Zgm3C9LtLyUiAUtHIrvnM9aCFaTuehgx/dsUyEmZtrX8J
         Mpm5S3TgqsmqzeNWH1rIScrCMtD0vWPBhXvoYKPH+1dFiSv3EsotX1zvUJt/rSX7qrQr
         Pmlf5n6qQl4r/tDTk/f6zCQS8pnvoWzB11QpisQjkulA2i7OsiK6NVMB808IFeBhJL0q
         ahAt803r/M+awlnXry3i48PBGPZtMb5CI23dPLdhM9+F2Ig4pn7ZJ/tARDvDz0hzT+eb
         h43h5PFRrezjoLoltuIv5iu66XY+D0NnHEMZ3ygY5b3tUmllDCezqK/n8CP5Ant/y5cH
         yLgA==
X-Gm-Message-State: AOAM5333ug/4usFvVy6xPHJ1rjF53OooLnEof8jRD1wSPppeS53A6oqq
        EsK0BFSDwHe0Vaz+XNpaKv6MeiIBxBMYQyGLLIT643vYXtcrfOOLzaxozjUUPK+IljEFhGtsoEt
        Faof7CIBMSIuHWFB6GFQ2RwXvRdCuss7SVQGdt7Smc/b9BEqGs0ONCdvZljuYBpfoDI/DonM=
X-Received: by 2002:aa7:91d7:0:b029:3c9:7e08:cc97 with SMTP id z23-20020aa791d70000b02903c97e08cc97mr1018895pfa.35.1631158738926;
        Wed, 08 Sep 2021 20:38:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQJBjPtnT/9NydMRs5zUBAQZ8T7KWr0LJ1HhoKy64aKphFDF8yc5mrt5K8ivRtTI82r2hCoQ==
X-Received: by 2002:aa7:91d7:0:b029:3c9:7e08:cc97 with SMTP id z23-20020aa791d70000b02903c97e08cc97mr1018862pfa.35.1631158738212;
        Wed, 08 Sep 2021 20:38:58 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm382834pga.39.2021.09.08.20.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 20:38:57 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed when
 file scrypted
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210903081510.982827-1-xiubli@redhat.com>
 <20210903081510.982827-3-xiubli@redhat.com>
 <34538b56f366596fa96a8da8bf1a60f1c1257367.camel@kernel.org>
 <19fac1bf-804c-1577-7aa8-9dcfa52418f9@redhat.com>
 <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fabbaeae-d63e-a2e2-0717-47afea66f82f@redhat.com>
Date:   Thu, 9 Sep 2021 11:38:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/8/21 9:57 PM, Jeff Layton wrote:
> On Wed, 2021-09-08 at 17:37 +0800, Xiubo Li wrote:
>> On 9/8/21 12:26 AM, Jeff Layton wrote:
>>> On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When truncating the file, it will leave the MDS to handle that,
>>>> but the MDS won't update the file contents. So when the fscrypt
>>>> is enabled, if the truncate size is not aligned to the block size,
>>>> the kclient will round up the truancate size to the block size and
>>>> leave the the last block untouched.
>>>>
>>>> The opaque fscrypt_file field will be used to tricker whether the
>>>> last block need to do the rmw to truncate the a specified block's
>>>> contents, we can get which block needs to do the rmw by round down
>>>> the fscrypt_file.
>>>>
>>>> In kclient side, there is not need to do the rmw immediately after
>>>> the file is truncated. We can defer doing that whenever the kclient
>>>> will update that block in late future. And before that any kclient
>>>> will check the fscrypt_file field when reading that block, if the
>>>> fscrypt_file field is none zero that means the related block needs
>>>> to be zeroed in range of [fscrypt_file, round_up(fscrypt_file + PAGE_SIZE))
>>>> in pagecache or readed data buffer.
>>>>
>>> s/PAGE_SIZE/CEPH_FSCRYPT_BLOCK_SIZE/
>>>
>>> Yes, on x86_64 they are equal, but that's not the case on all arches.
>>> Also, we are moving toward a pagecache that may hold larger pages on
>>> x86_64 too.
>>>    
>> Okay.
>>>> Once the that block contents are updated and writeback
>>>> kclient will reset the fscrypt_file field in MDS side, then 0 means
>>>> no need to care about the truncate stuff any more.
>>>>
>>> I'm a little unclear on what the fscrypt_file actually represents here.
>>>
>>> I had proposed that we just make the fscrypt_file field hold the
>>> "actual" i_size and we'd make the old size field always be a rounded-
>>> up version of the size. The MDS would treat that as an opaque value
>>> under Fw caps, and the client could use that field to determine i_size.
>>> That has a side benefit too -- if the client doesn't support fscrypt,
>>> it'll see the rounded-up sizes which are close enough and don't violate
>>> any POSIX rules.
>>>
>>> In your version, fscrypt_file also holds the actual size of the inode,
>>> but sometimes you're zeroing it out, and I don't understand why:
>> I think I forgot to fix this after I adapt to multiple ftruncates case,
>> this patch is not correctly handling the "actual" file size.
>>
>> I just want the fscrypt_file field always to hold the offset from which
>> the contents needed to be zeroed, and the range should be [fscrypt_file,
>> round_up(fscrypt_file +CEPH_FSCRYPT_BLOCK_SIZE)).
>>
>> In single ftruncate case the fscrypt_file should equal to the "actual"
>> file size. Then the "req->r_args.setattr.size = attr->ia_size" and
>> "req->r_args.setattr.old_size = isize", no need to round up in
>> __ceph_setattr() in kclient side, and leave the MDS to do that, but we
>> need to pass the CEPH_FSCRYPT_BLOCK_SIZE at the same time.
>>
> I'm really not a fan of pushing this logic into the MDS. Why does it
> need to know anything about the CEPH_FSCRYPT_BLOCK_SIZE at all?

 From your current patch set, you are rounding up the 
"req->r_args.setattr.size" and "req->r_args.setattr.old_size" to the 
BLOCK end in __ceph_setattr().

Without considering keep the file scryption logic in kclient only, I 
need the "req->r_args.setattr.size" to keep the file's real size.

Since the MDS will do the truncate stuff. And if we won't round the 
"req->r_args.setattr.size" up to the BLOCK end any more, then the MDS 
needs to know whether and how to round up the file size to the block end 
when truncating the file. Because the fscrypt_file won't record the 
file's real size any more, it maybe zero, more detail please see the 
example below.

Yeah, but as you mentioned bellow if we will keep the file scryption 
logic in kclient only, I need one extra field to do the defer rmw:

struct fscrypt_file {

     u64 file_real_size;         // always keep the file's real size and 
the "req->r_args.setattr.size = round_up(file_real_size, BLOCK_SIZE)" as 
you do in your current patch set.

     u64 file_truncate_offset;  // this will always record in which 
BLOCK we need to do the rmw, this maybe 0 or located in the file's LAST 
block and maybe not, more detail please the example below.

}

The "file_truncate_offset" member will be what I need to do the defer rmw.


>> But in multiple ftruncates case if the second ftruncate has a larger
>> size, the fscrypt_file won't be changed and the ceph backend will help
>> zero the extended part, but we still need to zero the contents in the
>> first ftruncate. If the second ftruncate has a smaller size, the
>> fscrypt_file need to be updated and always keeps the smaller size.
>>
> I don't get it. Maybe you can walk me through a concrete example of how
> racing ftruncates are a problem?

Sorry for confusing.

For example:

1), if there has a file named "bar", and currently the size is 100K 
bytes, the CEPH_FSCRYPT_BLOCK_SIZE size equals to 4K.

2), first ftruncate("bar", 7K) comes, then both the file real size and 
"file_truncate_offset" will be set to 7K, then in MDS it will truncate 
the file from 8K, and the last block's [7K, 8K) contents need to be 
zeroed anyway later.

3), immediately a second ftruncate("bar", 16K) comes, from the ftruncate 
man page it says the new extended [7K, 16K) should be zeroed when 
truncating the file. That means the OSD should help zero the [8K, 16K), 
but won't touch the block [4K, 8K), in which the [7K, 8K) contents still 
needs to be zeroed. So in this case the "file_truncate_offset" won't be 
changed and still be 7K. Then the "file_truncate_offset" won't be 
located in the last block of the file any more.

4), if the second ftruncate in step 3) the new size is 3K, then the MDS 
will truncate the file from 4K and [7K, 8K) contents will be discard 
anyway, so we need to update the "file_truncate_offset" to 3K, that 
means a new BLOCK [0K, 4K) needs to do the rmw, by zeroing the [3K, 4K).

5), if the new truncate in step 3) the new size is 4K, since the 4K < 7K 
and 4K is aligned to the BLOCK size, so no need to rmw any block any 
more, then we can just clear the "file_truncate_offset" field.


For defer RMW logic please see the following example:



> Suppose we have a file and client1 truncates it down from a large size
> to 7k. client1 then sends the MDS a SETATTR to truncate it at 8k, and
> does a RMW on the last (4k) block. client2 comes along at the same time
> and truncates it up to 13k. client2 issues a SETATTR to extend the file
> to 16k and does a RMW on the last block too (which would presumably
> already be all zeroes anyway).

I think you meant in the none defer RMW case, this is not what my defer 
RMW approach will do.

After the client1 truncated the file, it won't do the RMW if it won't 
write any data to that file, and then we assume the client1 is unmounted 
immediately.

And when the client1 is truncating the file, it will update the 
"file_truncate_offset" to 7K, which means the [7K, 8K) in the LAST block 
needs to be zeroed.

Then the client2 reads that the file size is 7K and the 
"file_truncate_offset" is 7K too, and the client2 wants to truncate the 
file up to 13K. Since the OSD should help us zero the extended part [8K, 
13K] when truncating, but won't touch the block [4K, 8K), for which it 
still needs to do the RMW. Then the client2 is unmounted too before 
writing any data to the file. After this the "file_truncate_offset" 
won't be located in the file's LAST block any more.

After that if the client3 will update the whole file's contents, it will 
read all the file 13K bytes contents to local page buffers, since the 
"file_truncate_offset" is 7K and then in the page buffer the range [7K, 
8K) will be zeroed just after the contents are dencrypted inplace. Then 
if the client3 successfully flushes that dirty data back and then the 
deferred RMW for block [4K, 8K) should be done at the same time, and the 
"file_truncate_offset" should be cleared too.

While if the client3 won't update the block [4K, 8K), the 
"file_truncate_offset" will be kept all the time until the above RMW is 
done in future.


BRs

- Xiubo


>
> Maybe I'm missing something obvious, but I don't see how any of this is
> an issue? Where does the race come in?
>
>>> 1) What benefit does this extra complexity provide?
>> Just in case for multiple ftruncates case as above.
>>
>>> 2) once you zero out that value, how do you know what the real i_size
>>> is? I assume the old size field will hold a rounded-up size (mostly for
>>> the benefit of the MDS), so you don't have a record of the real i_size
>>> at that point.
>> As above mentioned, the MDS will help do the round up instead and the
>> "setattr.size" and "setattr.old_size" won't do the round up any more in
>> kclient side.
>>
>
> I really don't understand what this is fixing and why you need to push
> the rounding logic into the MDS. fscrypt is largely a client side
> feature, and I think it'd be best to keep as much of the logic in the
> client as possible.

>
>>> Note that there is no reason you can't store _more_ than just a size in
>>> fscrypt_file. For example, If you need extra flags to indicate
>>> truncation/rmw state, then you could just make it hold a struct that has
>>> the size and a flags field.
>> Yeah, a struct is a good idea, something likes:
>>
>> struct fscrypt_file {
>>
>>       u64 truncate_offset;
>>
>>       u8 fscrypt_block_size;  // in kbytes
>>
>>       ...
>>
>> };
>>
>>
>>>> There has one special case and that is when there have 2 ftruncates
>>>> are called:
>>>>
>>>> 1) If the second's size equals to the first one, do nothing about
>>>>      the fscrypt_file.
>>>> 2) If the second's size is smaller than the first one, then we need
>>>>      to update the fscrypt_file with new size.
>>>> 3) If the second's size is larger than the first one, then we must
>>>>      leave what the fscrypt_file is. Because we always need to truncate
>>>>      more.
>>>>
>>>> Add one CEPH_CLIENT_CAPS_RESET_FSCRYPT_FILE flag in the cap reqeust
>>>> to tell the MDS to reset the scrypt_file field once the specified
>>>> block has been updated, so there still need to adapt to this in the
>>>> MDS PR.
>>>>
>>>> And also this patch just assume that all the buffer and none buffer
>>>> read/write related enscrypt/descrypt work has been done.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/addr.c  | 19 ++++++++++++++-
>>>>    fs/ceph/caps.c  | 24 +++++++++++++++++++
>>>>    fs/ceph/file.c  | 62 ++++++++++++++++++++++++++++++++++++++++++++++---
>>>>    fs/ceph/inode.c | 27 ++++++++++++++++++---
>>>>    fs/ceph/super.h | 12 ++++++++--
>>>>    5 files changed, 135 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>> index 6d3f74d46e5b..9f1dd2fc427d 100644
>>>> --- a/fs/ceph/addr.c
>>>> +++ b/fs/ceph/addr.c
>>>> @@ -212,6 +212,7 @@ static bool ceph_netfs_clamp_length(struct netfs_read_subrequest *subreq)
>>>>    static void finish_netfs_read(struct ceph_osd_request *req)
>>>>    {
>>>>    	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
>>>> +	struct ceph_inode_info *ci = ceph_inode(req->r_inode);
>>>>    	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
>>>>    	struct netfs_read_subrequest *subreq = req->r_priv;
>>>>    	int num_pages;
>>>> @@ -234,8 +235,15 @@ static void finish_netfs_read(struct ceph_osd_request *req)
>>>>    
>>>>    	netfs_subreq_terminated(subreq, err, true);
>>>>    
>>>> +	/* FIXME: This should be done after descryped */
>>>> +	if (req->r_result > 0)
>>>> +		ceph_try_to_zero_truncate_block_off(ci, osd_data->alignment,
>>>> +						    osd_data->length,
>>>> +						    osd_data->pages);
>>>> +
>>> The 3rd arg to ceph_try_to_zero_truncate_block_off is end_pos, but here
>>> you're passing in the length of the OSD write. Doesn't that need to
>>> added to the pos of the write?
>> Yeah, it should be the page_off instead.
>>
>>
>>> I'm also a little unclear as to why you need to adjust the truncation
>>> offset at this point.
>> It won't, the ceph_try_to_zero_truncate_block_off() will only zero the
>> readed pages in range of [fscrypt_off, round_up(fscrypt_file
>> +CEPH_FSCRYPT_BLOCK_SIZE)).
>>
>>
>>>>    	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
>>>>    	ceph_put_page_vector(osd_data->pages, num_pages, false);
>>>> +
>>>>    	iput(req->r_inode);
>>>>    }
>>>>    
>>>> @@ -555,8 +563,10 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>    				  req->r_end_latency, len, err);
>>>>    
>>>>    	ceph_osdc_put_request(req);
>>>> -	if (err == 0)
>>>> +	if (err == 0) {
>>>> +		ceph_reset_truncate_block_off(ci, page_off, len);
>>>>    		err = len;
>>>> +	}
>>>>    
>>>>    	if (err < 0) {
>>>>    		struct writeback_control tmp_wbc;
>>>> @@ -661,10 +671,17 @@ static void writepages_finish(struct ceph_osd_request *req)
>>>>    					   (u64)osd_data->length);
>>>>    		total_pages += num_pages;
>>>>    		for (j = 0; j < num_pages; j++) {
>>>> +			u64 page_off;
>>>> +
>>>>    			page = osd_data->pages[j];
>>>>    			BUG_ON(!page);
>>>>    			WARN_ON(!PageUptodate(page));
>>>>    
>>>> +			page_off = osd_data->alignment + j * PAGE_SIZE;
>>>> +			if (rc >= 0)
>>>> +			    ceph_reset_truncate_block_off(ci, page_off,
>>>> +							  page_off + PAGE_SIZE);
>>>> +
>>>>    			if (atomic_long_dec_return(&fsc->writeback_count) <
>>>>    			     CONGESTION_OFF_THRESH(
>>>>    					fsc->mount_options->congestion_kb))
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index d628dcdbf869..a211ab4c3f7a 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -1425,6 +1425,9 @@ static vthatoid __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>>>>    			}
>>>>    		}
>>>>    	}
>>>> +	if (ci->i_truncate_block_off < 0)
>>>> +		flags |= CEPH_CLIENT_CAPS_RESET_FSCRYPT_FILE;It sounds like you want to do something quite different from what I originally proposed.
>>>> +
>>>>    	arg->flags = flags;
>>>>    	arg->encrypted = IS_ENCRYPTED(inode);
>>>>    	if (ci->fscrypt_auth_len &&
>>>> @@ -3155,6 +3158,27 @@ void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
>>>>    	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_NO_CHECK);
>>>>    }
>>>>    
>>>> +/*
>>>> + * Clear the i_truncate_block_off and fscrypt_file
>>>> + * if old last encrypted block has been updated.
>>>> + */
>>>> +void __ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
>>>> +				      u64 start_pos, u64 end_pos)
>>>> +{
>>>> +	if (ci->i_truncate_block_off > 0 &&
>>>> +	    ci->i_truncate_block_off >= start_pos &&
>>>> +	    ci->i_truncate_block_off < end_pos)
>>>> +		ci->i_truncate_block_off = 0;
>>>> +}
>>>> +
>>>> +void ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
>>>> +				    u64 start_pos, u64 end_pos)
>>>> +{
>>>> +	spin_lock(&ci->i_ceph_lock);
>>>> +	__ceph_reset_truncate_block_off(ci, start_pos, end_pos);
>>>> +	spin_unlock(&ci->i_ceph_lock);
>>>> +}
>>>> +
>>>>    /*
>>>>     * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
>>>>     * context.  Adjust per-snap dirty page accounting as appropriate.
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 6e677b40410e..cfa4cbe08c10 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -885,10 +885,34 @@ static void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
>>>>    	}
>>>>    }
>>>>    
>>>> +void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
>>>> +					 u64 start_pos, u64 end_pos,
>>>> +					 struct page **pages)
>>>> +{
>>>> +	u64 zoff, zlen;
>>>> +
>>>> +	spin_lock(&ci->i_ceph_lock);
>>>> +	if (ci->i_truncate_block_off >= start_pos &&
>>>> +			ci->i_truncate_block_off < end_pos) {
>>>> +		zoff = ci->i_truncate_block_off - start_pos;
>>>> +		zlen = round_up(ci->i_truncate_block_off, PAGE_SIZE) - ci->i_truncate_block_off;
>>>> +
>>>> +		spin_unlock(&ci->i_ceph_lock);
>>>> +		ceph_zero_page_vector_range(zoff, zlen, pages);
>>>> +		spin_lock(&ci->i_ceph_lock);
>>>> +	}
>>>> +	spin_unlock(&ci->i_ceph_lock);
>>>> +}
>>>>    #else
>>>>    static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
>>>>    {
>>>>    }
>>>> +
>>>> +void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
>>>> +					 u64 start_pos, u64 end_pos,
>>>> +					 struct page **pages)
>>>> +{
>>>> +}
>>>>    #endif
>>>>    
>>>>    /*
>>>> @@ -1030,6 +1054,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>>    			ret += zlen;
>>>>    		}
>>>>    
>>>> +		/*
>>>> +		 * If the inode is ENCRYPTED the read_off is aligned to PAGE_SIZE
>>>> +		 */
>>>> +		ceph_try_to_zero_truncate_block_off(ci, read_off,
>>>> +						    read_off + read_len,
>>>> +						    pages);
>>>> +
>>>>    		idx = 0;
>>>>    		left = ret > 0 ? ret : 0;
>>>>    		while (left > 0) {
>>>> @@ -1413,12 +1444,34 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>>>>    
>>>>    		size = i_size_read(inode);
>>>>    		if (!write) {
>>>> +			struct iov_iter i;
>>>> +			size_t boff;
>>>> +			int zlen;
>>>> +
>>>>    			if (ret == -ENOENT)
>>>>    				ret = 0;
>>>> +
>>>> +			/* Zero the truncate block off */
>>>> +			spin_lock(&ci->i_ceph_lock);
>>>> +			boff = ci->i_truncate_block_off;
>>>> +			if (IS_ENCRYPTED(inode) && ret > 0 && boff > 0 &&
>>>> +			    boff >= (iocb->ki_pos & PAGE_MASK) &&
>>>> +			    boff < round_up(ret, PAGE_SIZE)) {
>>>> +				int advance = 0;
>>>> +rovide?
>>>> +				zlen = round_up(boff, PAGE_SIZE) - boff;
>>>> +				if (ci->i_truncate_block_off >= iocb->ki_pos)
>>>> +					advance = boff - iocb->ki_pos;
>>>> +
>>>> +				iov_iter_bvec(&i, READ, bvecs, num_pages, len);
>>>> +				iov_iter_advance(&i, advance);
>>>> +				iov_iter_zero(zlen, &i);
>>>> +			}
>>>> +			spin_unlock(&ci->i_ceph_lock);
>>>> +
>>>>    			if (ret >= 0 && ret < len && pos + ret < size) {
>>>> -				struct iov_iter i;
>>>> -				int zlen = min_t(size_t, len - ret,
>>>> -						 size - pos - ret);
>>>> +				zlen = min_t(size_t, len - ret,
>>>> +					     size - pos - ret);
>>>>    
>>>>    				iov_iter_bvec(&i, READ, bvecs, num_pages, len);
>>>>    				iov_iter_advance(&i, ret);
>>>> @@ -1967,6 +2020,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>    	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>>    	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>>>    	struct ceph_cap_flush *prealloc_cf;
>>>> +	u64 start_pos = iocb->ki_pos;
>>>>    	ssize_t count, written = 0;
>>>>    	int err, want, got;
>>>>    	bool direct_lock = false;
>>>> @@ -2110,6 +2164,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>    		int dirty;
>>>>    
>>>>    		spin_lock(&ci->i_ceph_lock);
>>>> +		__ceph_reset_truncate_block_off(ci, start_pos, iocb->ki_pos);
>>>> +
>>>>    		ci->i_inline_version = CEPH_INLINE_NONE;
>>>>    		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
>>>>    					       &prealloc_cf);
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 1a4c9bc485fc..c48c77c1bcf4 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -625,6 +625,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>>>    	ci->fscrypt_auth = NULL;
>>>>    	ci->fscrypt_auth_len = 0;
>>>>    #endif
>>>> +	ci->i_truncate_block_off = 0;
>>>>    
>>>>    	return &ci->vfs_inode;
>>>>    }
>>>> @@ -1033,11 +1034,24 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>>>>    
>>>>    		pool_ns = old_ns;
>>>>    
>>>> +		/* the fscrypt_file is 0 means the file content truncate has been done */
>>>>    		if (IS_ENCRYPTED(inode) && size &&
>>>> -		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
>>>> +		    iinfo->fscrypt_file_len == sizeof(__le64) &&
>>>> +		    __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file) > 0) {
>>>>    			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
>>>>    			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
>>>>    				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
>>>> +
>>>> +			/*
>>>> +			 * If the second truncate come just after the first
>>>> +			 * truncate, and if the second has a larger size there
>>>> +			 * is no need to update the i_truncate_block_off.
>>>> +			 * Only when the second one has a smaller size, that
>>>> +			 * means we need to truncate more.
>>>> +			 */
>>>> +			if (ci->i_truncate_block_off > 0 &&
>>>> +			    size < ci->i_truncate_block_off)
>>>> +				ci->i_truncate_block_off = size;
>>>>    		}
>>>>    
>>>>    		queue_trunc = ceph_fill_file_size(inode, issued,
>>>> @@ -2390,8 +2404,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>    				req->r_args.setattr.old_size =
>>>>    					cpu_to_le64(round_up(isize,
>>>>    							     CEPH_FSCRYPT_BLOCK_SIZE));
>>>> -				req->r_fscrypt_file = attr->ia_size;
>>>> -				/* FIXME: client must zero out any partial blocks! */
>>>> +				if (attr->ia_size < isize) {
>>>> +					if(IS_ALIGNED(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE))
>>>> +						req->r_fscrypt_file = 0;
>>>> +					else
>>>> +						req->r_fscrypt_file = attr->ia_size;
>>>> +					/* FIXME: client must zero out any partial blocks! */
>>>> +				} else if (attr->ia_size > isize) {
>>>> +					req->r_fscrypt_file = attr->ia_size;
>>>> +				}
>>>>    			} else {
>>>>    				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>>>>    				req->r_args.setattr.old_size = cpu_to_le64(isize);
>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>> index 7f3976b3319d..856caeb25fb6 100644
>>>> --- a/fs/ceph/super.h
>>>> +++ b/fs/ceph/super.h
>>>> @@ -443,9 +443,9 @@ struct ceph_inode_info {
>>>>    	struct fscache_cookie *fscache;
>>>>    #endif
>>>>    	u32 fscrypt_auth_len;
>>>> -	u32 fscrypt_file_len;
>>>>    	u8 *fscrypt_auth;
>>>> -	u8 *fscrypt_file;
>>>> +	/* need to zero the last block when decrypting the content to pagecache */
>>>> +	size_t i_truncate_block_off;
>>>>    
>>> Ugh, do we really need yet another field in the inode? This seems
>>> totally unnecessary, but maybe I'm missing some subtlety in the
>>> truncation handling that requires this extra tracking.
>>>
>>> What is this intended to represent anyway?
>> Just a draft patch. And I remove the unused "u8 *fscrypt_file" member.
>>
>> We can remove this and just reuse the "u8 *fscrypt_file" here.
>>
>> After the inode is filled, this will keep the offset from which it needs
>> to do the zero stuff after reading to the local pagecache or buffer.
>>
>>>>    	errseq_t i_meta_err;
>>>>    
>>>> @@ -1192,6 +1192,10 @@ extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
>>>>    extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had);
>>>>    extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
>>>>    					    int had);
>>>> +extern void __ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
>>>> +					    u64 start_pos, u64 end_pos);
>>>> +extern void ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
>>>> +					  u64 start_pos, u64 end_pos);
>>>>    extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>>>    				       struct ceph_snap_context *snapc);
>>>>    extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>>>> @@ -1282,6 +1286,10 @@ extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
>>>>    extern void ceph_fs_debugfs_init(struct ceph_fs_client *client);
>>>>    extern void ceph_fs_debugfs_cleanup(struct ceph_fs_client *client);
>>>>    
>>>> +extern void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
>>>> +						u64 start_pos, u64 end_pos,
>>>> +						struct page **pages);
>>>> +
>>>>    /* quota.c */
>>>>    static inline bool __ceph_has_any_quota(struct ceph_inode_info *ci)
>>>>    {

