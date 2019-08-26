Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9899C780
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 05:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfHZDF3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Aug 2019 23:05:29 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:43637 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbfHZDF3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Aug 2019 23:05:29 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABnt19VTGNdXPl8AQ--.42S2;
        Mon, 26 Aug 2019 11:04:53 +0800 (CST)
Subject: Re: [PATCH v3 12/15] rbd: introduce rbd_journal_allocate_tag to
 allocate journal tag for rbd client
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
 <1564393377-28949-13-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP_vw7uDUERh8iOOy4N8Ph9Ddh2qiLpkBFd=1fwQK=yK9Q@mail.gmail.com>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D634C55.6080000@easystack.cn>
Date:   Mon, 26 Aug 2019 11:04:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_vw7uDUERh8iOOy4N8Ph9Ddh2qiLpkBFd=1fwQK=yK9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABnt19VTGNdXPl8AQ--.42S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrW5Zr18CF4DCFWUXr43KFg_yoW7JFykpF
        yDGF4rCrZ8AFy7J34xZF4rAFyFq348Kry2gr9I93Z7JasayrZ2yr12kr95urW7AFZrG3W8
        tr45X398C34DK3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUbXocUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiRBUdelbdG7P0aAAAsJ
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/19/2019 06:37 PM, Ilya Dryomov wrote:
> On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>> rbd_journal_allocate_tag() get the client by client id and allocate an uniq tag
>> for this client.
>>
>> All journal events from this client will be tagged by this tag.
>>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>> ---
>>   drivers/block/rbd.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 112 insertions(+)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 337a20f..86008f2 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -28,16 +28,19 @@
>>
>>    */
>>
>> +#include <linux/crc32c.h>
> What is this include for?
>
>>   #include <linux/ceph/libceph.h>
>>   #include <linux/ceph/osd_client.h>
>>   #include <linux/ceph/mon_client.h>
>>   #include <linux/ceph/cls_lock_client.h>
>>   #include <linux/ceph/striper.h>
>>   #include <linux/ceph/decode.h>
>> +#include <linux/ceph/journaler.h>
>>   #include <linux/parser.h>
>>   #include <linux/bsearch.h>
>>
>>   #include <linux/kernel.h>
>> +#include <linux/bio.h>
> Same here.

These include is not necessary for this patch, I will move them later.
>
>>   #include <linux/device.h>
>>   #include <linux/module.h>
>>   #include <linux/blk-mq.h>
>> @@ -470,6 +473,14 @@ enum rbd_dev_flags {
>>          RBD_DEV_FLAG_REMOVING,  /* this mapping is being removed */
>>   };
>>
>> +#define        LOCAL_MIRROR_UUID       ""
>> +#define        LOCAL_CLIENT_ID         ""
>> +
>> +struct rbd_journal {
>> +       struct ceph_journaler *journaler;
>> +       uint64_t                tag_tid;
>> +};
> I think these two fields can be embedded into struct rbd_device
> directly.


>
>> +
>>   static DEFINE_MUTEX(client_mutex);     /* Serialize client creation */
>>
>>   static LIST_HEAD(rbd_dev_list);    /* devices */
>> @@ -6916,6 +6927,107 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
>>          return ret;
>>   }
>>
>> +typedef struct rbd_journal_tag_predecessor {
>> +       bool commit_valid;
>> +       uint64_t tag_tid;
>> +       uint64_t entry_tid;
>> +       uint32_t uuid_len;
>> +       char *mirror_uuid;
>> +} rbd_journal_tag_predecessor;
>> +
>> +typedef struct rbd_journal_tag_data {
>> +       struct rbd_journal_tag_predecessor predecessor;
>> +       uint32_t uuid_len;
>> +       char *mirror_uuid;
>> +} rbd_journal_tag_data;
> Why typedef these structs?

There was a reference to same struct when introduce them. But now this 
typedef looks
not necessary.
>
>> +
>> +static uint32_t tag_data_encoding_size(struct rbd_journal_tag_data *tag_data)
>> +{
>> +       // sizeof(uuid_len) 4 + uuid_len + 1 commit_valid + 8 tag_tid +
>> +       // 8 entry_tid + 4 sizeof(uuid_len) + uuid_len
>> +       return (4 + tag_data->uuid_len + 1 + 8 + 8 + 4 +
>> +               tag_data->predecessor.uuid_len);
>> +}
>> +
>> +static void predecessor_encode(void **p, void *end,
>> +                              struct rbd_journal_tag_predecessor *predecessor)
>> +{
>> +       ceph_encode_string(p, end, predecessor->mirror_uuid,
>> +                          predecessor->uuid_len);
>> +       ceph_encode_8(p, predecessor->commit_valid);
>> +       ceph_encode_64(p, predecessor->tag_tid);
>> +       ceph_encode_64(p, predecessor->entry_tid);
>> +}
>> +
>> +static int rbd_journal_encode_tag_data(void **p, void *end,
>> +                                      struct rbd_journal_tag_data *tag_data)
>> +{
>> +       struct rbd_journal_tag_predecessor *predecessor = &tag_data->predecessor;
>> +
>> +       ceph_encode_string(p, end, tag_data->mirror_uuid, tag_data->uuid_len);
>> +       predecessor_encode(p, end, predecessor);
>> +
>> +       return 0;
>> +}
>> +
>> +static int rbd_journal_allocate_tag(struct rbd_journal *journal)
>> +{
>> +       struct ceph_journaler_tag tag = {};
>> +       struct rbd_journal_tag_data tag_data = {};
>> +       struct ceph_journaler *journaler = journal->journaler;
>> +       struct ceph_journaler_client *client;
>> +       struct rbd_journal_tag_predecessor *predecessor;
>> +       struct ceph_journaler_object_pos *position;
>> +       void *orig_buf, *buf, *p, *end;
>> +       uint32_t buf_len;
>> +       int ret;
>> +
>> +       ret = ceph_journaler_get_cached_client(journaler, LOCAL_CLIENT_ID, &client);
>> +       if (ret)
>> +               goto out;
>> +
>> +       position = list_first_entry(&client->object_positions,
>> +                                   struct ceph_journaler_object_pos, node);
>> +
>> +       predecessor = &tag_data.predecessor;
>> +       predecessor->commit_valid = true;
>> +       predecessor->tag_tid = position->tag_tid;
>> +       predecessor->entry_tid = position->entry_tid;
>> +       predecessor->uuid_len = 0;
>> +       predecessor->mirror_uuid = LOCAL_MIRROR_UUID;
>> +
>> +       tag_data.uuid_len = 0;
>> +       tag_data.mirror_uuid = LOCAL_MIRROR_UUID;
> If ->mirror_uuid is always "" (and ->uuid_len is always 0), drop them
> and encode 0 directly instead of using ceph_encode_string().

I use these name to represent the meaning for each encoding. But I am
am okey to drop them and add a comment here.

Thanx
>
> Thanks,
>
>                  Ilya
>


