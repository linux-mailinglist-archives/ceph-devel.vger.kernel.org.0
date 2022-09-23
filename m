Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3A5E729B
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Sep 2022 05:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiIWD6d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Sep 2022 23:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIWD6b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Sep 2022 23:58:31 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B41B911A6B4
        for <ceph-devel@vger.kernel.org>; Thu, 22 Sep 2022 20:58:29 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 21A4E6140A;
        Fri, 23 Sep 2022 13:58:27 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id OpLWocTvumrF; Fri, 23 Sep 2022 13:58:26 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 97CF061395;
        Fri, 23 Sep 2022 13:58:26 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 7DDDC6803CA; Fri, 23 Sep 2022 13:58:26 +1000 (AEST)
Date:   Fri, 23 Sep 2022 13:58:26 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220923035826.GA1830185@onthe.net.au>
References: <20220913012043.GA568834@onthe.net.au>
 <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au>
 <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au>
 <20220919074321.GA1363634@onthe.net.au>
 <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
 <20220921013629.GA1583272@onthe.net.au>
 <CAOi1vP__Mj9Qyb=WsUxo7ja5koTS+0eavsnWH=X+DTest4spaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <CAOi1vP__Mj9Qyb=WsUxo7ja5koTS+0eavsnWH=X+DTest4spaQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi Ilya,

On Wed, Sep 21, 2022 at 12:40:54PM +0200, Ilya Dryomov wrote:
> On Wed, Sep 21, 2022 at 3:36 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>> What can make a "rbd unmap" fail, assuming the device is not
>>> mounted and not (obviously) open by any other processes?

OK, I'm confident I now understand the cause of this problem. The 
particular machine where I'm mounting the rbd snapshots is also running 
some containerised ceph services. The ceph containers are 
(bind-)mounting the entire host filesystem hierarchy on startup, and if 
a ceph container happens to start up whilst a rbd device is mounted, the 
container also has the rbd mounted, preventing the host from unmapping 
the device even after the host has unmounted it. (More below.)

This brings up a couple of issues...

Why is the ceph container getting access to the entire host filesystem 
in the first place?

Even if I mount an rbd device with the "unbindable" mount option, which 
is specifically supposed to prevent bind mounts to that filesystem, the 
ceph containers still get the mount - how / why??

If the ceph containers really do need access to the entire host 
filesystem, perhaps it would be better to do a "slave" mount, so if/when 
the hosts unmounts a filesystem it's also unmounted in the container[s].  
(Of course this also means any filesystems newly mounted in the host 
would also appear in the containers - but that happens anyway if the 
container is newly started).

>> An unsuccessful iteration looks like this:
>>
>> 18:37:31.885408 O 3294108 rbd29 0 mapper
>> 18:37:33.181607 R 3294108 rbd29 1 mapper
>> 18:37:33.182086 O 3294175 rbd29 0 systemd-udevd
>> 18:37:33.197982 O 3294691 rbd29 1 blkid
>> 18:37:42.712870 R 3294691 rbd29 2 blkid
>> 18:37:42.716296 R 3294175 rbd29 1 systemd-udevd
>> 18:37:42.738469 O 3298073 rbd29 0 mount
>> 18:37:49.339012 R 3298073 rbd29 1 mount
>> 18:37:49.339352 O 3298073 rbd29 0 mount
>> 18:38:51.390166 O 2364320 rbd29 1 rpc.mountd
>> 18:39:00.989050 R 2364320 rbd29 2 rpc.mountd
>> 18:53:56.054685 R 3313923 rbd29 1 init
>>
>> According to my script log, the first unmap attempt was at 18:39:42,
>> i.e. 42 seconds after rpc.mountd released the device. At that point the
>> the open_count was (or should have been?) 1 again allowing the unmap to
>> succeed - but it didn't. The unmap was retried every second until it
>
> For unmap to go through, open_count must be 0.  rpc.mountd at
> 18:39:00.989050 just decremented it from 2 to 1, it didn't release
> the device.

Yes - but my poorly made point was that, per the normal test iteration, 
some time shortly after rpc.mountd decremented open_count to 1, an 
"umount" command was run successfully (the test would have aborted if 
the umount didn't succeed) - but the "umount" didn't show up in the 
bpftrace output. Immediately after the umount a "rbd unmap" was run, 
which failed with "busy" - i.e. the open_count was still incremented.

>> eventually succeeded at 18:53:56, the same time as the mysterious 
>> "init" process ran - but also note there is NO "umount" process in 
>> there so I don't know if the name of the process recorded by bfptrace 
>> is simply incorrect (but how would that happen??) or what else could 
>> be going on.

Using "ps" once the unmap starts failing, then cross checking against 
the process id recorded for the mysterious "init" in the bpftrace 
output, reveals the full command line for the "init" is:

/dev/init -- /usr/sbin/ceph-volume inventory --format=json-pretty --filter-for-batch

I.e. it's the 'init' process of a ceph-volume container that eventually 
releases the open_count.

After doing a lot of learning about ceph and containers (podman in this 
case) and namespaces etc. etc., the problem is now known...

Ceph containers are started with '-v "/:/rootfs"' which bind mounts the 
entire host's filesystem hierarchy into the container. Specifically, if 
the host has mounted filesystems, they're also mounted within the 
container when it starts up. So, if a ceph container starts up whilst 
there is a filesystem mounted from an rbd mapped device, the container 
also has that mount - and it retains the mount even if the filesystem is 
unmounted in the host. So the rbd device can't be unmapped in the host 
until the filesystem is released by the container, either via an explicit 
umount within the container, or a umount from the host targetting the 
container namespace, or the container exits.

This explains the mysterious 51 rbd devices that I haven't been able to 
unmap for a week: they're all mounted within long-running ceph containers 
that happened to start up whilst those 51 devices were all mounted 
somewhere.  I've now been able to unmap those devices after unmounting the 
filesystems within those containers using:

umount --namespace "${pid_of_container}" "${fs}"


------------------------------------------------------------
An example demonstrating the problem
------------------------------------------------------------
#
# Mount a snapshot, with "unbindable"
#
host# {
   rbd=pool/name@snap
   dev=$(rbd device map "${rbd}")
   declare -p dev
   mount -oro,norecovery,nouuid,unbindable "${dev}" "/mnt"
   echo --
   grep "${dev}" /proc/self/mountinfo
   echo --
   ls /mnt
   echo --
}
declare -- dev="/dev/rbd30"
--
1463 22 252:480 / /mnt ro unbindable - xfs /dev/rbd30 ro,nouuid,norecovery
--
file1 file2 file3

#
# The mount is still visible if we start a ceph container
#
host# cephadm shell
root@host:/# ls /mnt
file1 file2 file3

#
# The device is not unmappable from the host...
#
host# umount /mnt
host# rbd device unmap "${dev}"
rbd: sysfs write failed
rbd: unmap failed: (16) Device or resource busy

#
# ...until we umount the filesystem within the container
#
#
host# lsns -t mnt
         NS TYPE NPROCS     PID USER             COMMAND
4026533050 mnt       2 3105356 root             /dev/init -- bash
host# umount --namespace 3105356 /mnt
host# rbd device unmap "${dev}"
   ## success
------------------------------------------------------------


>> The bpftrace script looks like this:
>
> It would be good to attach the entire script, just in case someone runs
> into a similar issue in the future and tries to debug the same way.

Attached.

Cheers,

Chris

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rbd-open-release.bpf"

#!/usr/bin/bpftrace
/*
 * log rbd opens and releases
 *
 * run like:
 *
 * bpftrace -I /lib/modules/$(uname -r)/source/drivers/block -I /lib/modules/$(uname -r)/build this_script
 *
 * This assumes you have the appropriate linux source and build
 * artifacts available on the machine where you're running bpftrace.
 *
 * Note:
 *   https://github.com/iovisor/bpftrace/pull/2315
 *   BTF for kernel modules
 *
 * Once that lands in your local bpftrace you hopefully don't need the linux
 * source and build stuff, nor the 'extracted' stuff below, and you should be
 * able to simply run this script like:
 *
 * chmod +x ./this_script
 * ./this_script
 *   
 */

////////////////////////////////////////////////////////////
// extracted from
//   linux/drivers/block/rbd.c
//
#include <linux/ceph/osdmap.h>

#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/blk-mq.h>

#include "rbd_types.h"

/*
 * An RBD device name will be "rbd#", where the "rbd" comes from
 * RBD_DRV_NAME above, and # is a unique integer identifier.
 */
#define DEV_NAME_LEN		32

/*
 * block device image metadata (in-memory version)
 */
struct rbd_image_header {
	/* These six fields never change for a given rbd image */
	char *object_prefix;
	__u8 obj_order;
	u64 stripe_unit;
	u64 stripe_count;
	s64 data_pool_id;
	u64 features;		/* Might be changeable someday? */

	/* The remaining fields need to be updated occasionally */
	u64 image_size;
	struct ceph_snap_context *snapc;
	char *snap_names;	/* format 1 only */
	u64 *snap_sizes;	/* format 1 only */
};

enum rbd_watch_state {
	RBD_WATCH_STATE_UNREGISTERED,
	RBD_WATCH_STATE_REGISTERED,
	RBD_WATCH_STATE_ERROR,
};

enum rbd_lock_state {
	RBD_LOCK_STATE_UNLOCKED,
	RBD_LOCK_STATE_LOCKED,
	RBD_LOCK_STATE_RELEASING,
};

/* WatchNotify::ClientId */
struct rbd_client_id {
	u64 gid;
	u64 handle;
};

struct rbd_mapping {
	u64                     size;
};

/*
 * a single device
 */
struct rbd_device {
	int			dev_id;		/* blkdev unique id */

	int			major;		/* blkdev assigned major */
	int			minor;
	struct gendisk		*disk;		/* blkdev's gendisk and rq */

	u32			image_format;	/* Either 1 or 2 */
	struct rbd_client	*rbd_client;

	char			name[DEV_NAME_LEN]; /* blkdev name, e.g. rbd3 */

	spinlock_t		lock;		/* queue, flags, open_count */

	struct rbd_image_header	header;
	unsigned long		flags;		/* possibly lock protected */
	struct rbd_spec		*spec;
	struct rbd_options	*opts;
	char			*config_info;	/* add{,_single_major} string */

	struct ceph_object_id	header_oid;
	struct ceph_object_locator header_oloc;

	struct ceph_file_layout	layout;		/* used for all rbd requests */

	struct mutex		watch_mutex;
	enum rbd_watch_state	watch_state;
	struct ceph_osd_linger_request *watch_handle;
	u64			watch_cookie;
	struct delayed_work	watch_dwork;

	struct rw_semaphore	lock_rwsem;
	enum rbd_lock_state	lock_state;
	char			lock_cookie[32];
	struct rbd_client_id	owner_cid;
	struct work_struct	acquired_lock_work;
	struct work_struct	released_lock_work;
	struct delayed_work	lock_dwork;
	struct work_struct	unlock_work;
	spinlock_t		lock_lists_lock;
	struct list_head	acquiring_list;
	struct list_head	running_list;
	struct completion	acquire_wait;
	int			acquire_err;
	struct completion	releasing_wait;

	spinlock_t		object_map_lock;
	u8			*object_map;
	u64			object_map_size;	/* in objects */
	u64			object_map_flags;

	struct workqueue_struct	*task_wq;

	struct rbd_spec		*parent_spec;
	u64			parent_overlap;
	atomic_t		parent_ref;
	struct rbd_device	*parent;

	/* Block layer tags. */
	struct blk_mq_tag_set	tag_set;

	/* protects updating the header */
	struct rw_semaphore     header_rwsem;

	struct rbd_mapping	mapping;

	struct list_head	node;

	/* sysfs related */
	struct device		dev;
	unsigned long		open_count;	/* protected by lock */
};

//
// end of extraction
////////////////////////////////////////////////////////////

kprobe:rbd_open {
  $bdev = (struct block_device *)arg0;
  $rbd_dev = (struct rbd_device *)($bdev->bd_disk->private_data);

  printf("%s O %d %s %lu %s\n",
    strftime("%T.%f", nsecs), pid, $rbd_dev->name, $rbd_dev->open_count, comm
  );
}

kprobe:rbd_release {
  $disk = (struct gendisk *)arg0;
  $rbd_dev = (struct rbd_device *)($disk->private_data);

  printf("%s R %d %s %lu %s\n",
    strftime("%T.%f", nsecs), pid, $rbd_dev->name, $rbd_dev->open_count, comm
  );
}

--n8g4imXOkfNTN/H1--
